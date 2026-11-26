import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_igl_cng/feature/numberPlateScanner/helper/plate_detector_service.dart';

/// Image quality metrics measured on a cropped plate before preprocessing.
class PlateQualityMetrics {
  const PlateQualityMetrics({
    required this.meanBrightness,
    required this.contrastSpan,
    required this.sharpness,
  });

  final double meanBrightness;
  final int contrastSpan;
  final double sharpness;

  bool get needsBrightnessOrContrastFix =>
      meanBrightness < 100 || meanBrightness > 205 || contrastSpan < 95;

  bool get needsSharpening => sharpness < 145.0;
}

class WorkerFrameRequest {
  const WorkerFrameRequest({
    required this.frameId,
    required this.yOrBgraBytes,
    required this.uBytes,
    required this.vBytes,
    required this.srcWidth,
    required this.srcHeight,
    required this.yRowStride,
    required this.yPixelStride,
    required this.uRowStride,
    required this.vRowStride,
    required this.uPixelStride,
    required this.vPixelStride,
    required this.isBgra,
    required this.rotationDegrees,
    required this.roiLeft,
    required this.roiTop,
    required this.roiRight,
    required this.roiBottom,
    this.allowSsdFallback = true,
  });

  final int frameId;
  final Uint8List yOrBgraBytes;
  final Uint8List? uBytes;
  final Uint8List? vBytes;
  final int srcWidth;
  final int srcHeight;
  final int yRowStride;
  final int yPixelStride;
  final int uRowStride;
  final int vRowStride;
  final int uPixelStride;
  final int vPixelStride;
  final bool isBgra;
  final int rotationDegrees;
  final double roiLeft;
  final double roiTop;
  final double roiRight;
  final double roiBottom;
  final bool allowSsdFallback;
}

class WorkerFrameResult {
  const WorkerFrameResult({
    required this.frameId,
    required this.detected,
    required this.framePrepMs,
    required this.detectMs,
    required this.cropPreprocessMs,
    required this.detectConfidence,
    required this.skewAngleDeg,
    required this.usedPerspectiveWarp,
    required this.usedContrastFix,
    required this.usedSharpen,
    required this.isTwoRowCandidate,
    this.detectorSource = 'none',
    this.primaryNv21,
    this.primaryW = 0,
    this.primaryH = 0,
    this.adaptiveNv21,
    this.topRowNv21,
    this.topRowW = 0,
    this.topRowH = 0,
    this.bottomRowNv21,
    this.bottomRowW = 0,
    this.bottomRowH = 0,
    this.error,
  });

  final int frameId;
  final bool detected;
  final int framePrepMs;
  final int detectMs;
  final int cropPreprocessMs;
  final double detectConfidence;
  final double skewAngleDeg;
  final bool usedPerspectiveWarp;
  final bool usedContrastFix;
  final bool usedSharpen;
  final bool isTwoRowCandidate;
  final String detectorSource;

  final Uint8List? primaryNv21;
  final int primaryW;
  final int primaryH;
  final Uint8List? adaptiveNv21;

  final Uint8List? topRowNv21;
  final int topRowW;
  final int topRowH;
  final Uint8List? bottomRowNv21;
  final int bottomRowW;
  final int bottomRowH;

  final String? error;
}

/// Persistent background Isolate session that caches the TFLite plate detector
/// and reusable RGB buffers so inference and preprocessing never block the UI
/// thread or spawn per-frame isolates.
class PlateWorkerSession {
  PlateWorkerSession._(
    this._isolate,
    this._sendPort,
    this._receivePort,
    this.diagnostics,
  );

  final Isolate _isolate;
  final SendPort _sendPort;
  final ReceivePort _receivePort;
  final DetectorDiagnostics diagnostics;

  final Map<int, Completer<WorkerFrameResult>> _pending = {};
  bool _disposed = false;

  static Future<PlateWorkerSession> start({
    required Uint8List ssdModelBytes,
    Uint8List? wpodModelBytes,
  }) async {
    final initReceive = ReceivePort();
    final isolate = await Isolate.spawn(
      _workerEntryPoint,
      initReceive.sendPort,
      debugName: 'PlateAnprWorker',
    );

    final mainReceive = ReceivePort();
    final SendPort workerPort = await initReceive.first as SendPort;
    initReceive.close();

    final readyCompleter = Completer<Object>();
    late final StreamSubscription<dynamic> sub;
    final Map<int, Completer<WorkerFrameResult>> pending = {};

    sub = mainReceive.listen((msg) {
      if (msg is Map<String, Object?>) {
        final type = msg['type'];
        if (type == 'init_done') {
          if (!readyCompleter.isCompleted) {
            readyCompleter.complete(msg['diag']!);
          }
        } else if (type == 'init_error') {
          if (!readyCompleter.isCompleted) {
            readyCompleter.completeError(StateError(msg['error'].toString()));
          }
        } else if (type == 'frame_result') {
          final result = msg['result'] as WorkerFrameResult;
          final c = pending.remove(result.frameId);
          c?.complete(result);
        }
      }
    });

    workerPort.send({
      'type': 'init',
      'replyPort': mainReceive.sendPort,
      'ssdBytes': TransferableTypedData.fromList([ssdModelBytes]),
      'wpodBytes': wpodModelBytes != null
          ? TransferableTypedData.fromList([wpodModelBytes])
          : null,
    });

    final diagObj = await readyCompleter.future.timeout(
      const Duration(seconds: 15),
    );
    final diag = diagObj as DetectorDiagnostics;

    final session = PlateWorkerSession._(
      isolate,
      workerPort,
      mainReceive,
      diag,
    );
    session._subscription = sub;
    session._pendingMap = pending;
    return session;
  }

  StreamSubscription<dynamic>? _subscription;
  Map<int, Completer<WorkerFrameResult>>? _pendingMap;

  Future<WorkerFrameResult> processFrame(WorkerFrameRequest req) {
    if (_disposed) {
      return Future.value(
        WorkerFrameResult(
          frameId: req.frameId,
          detected: false,
          framePrepMs: 0,
          detectMs: 0,
          cropPreprocessMs: 0,
          detectConfidence: 0,
          skewAngleDeg: 0,
          usedPerspectiveWarp: false,
          usedContrastFix: false,
          usedSharpen: false,
          isTwoRowCandidate: false,
          error: 'Worker disposed',
        ),
      );
    }

    final completer = Completer<WorkerFrameResult>();
    final map = _pendingMap ?? _pending;
    map[req.frameId] = completer;

    _sendPort.send({
      'type': 'frame',
      'frameId': req.frameId,
      'yOrBgra': TransferableTypedData.fromList([req.yOrBgraBytes]),
      'u': req.uBytes != null ? TransferableTypedData.fromList([req.uBytes!]) : null,
      'v': req.vBytes != null ? TransferableTypedData.fromList([req.vBytes!]) : null,
      'srcWidth': req.srcWidth,
      'srcHeight': req.srcHeight,
      'yRowStride': req.yRowStride,
      'yPixelStride': req.yPixelStride,
      'uRowStride': req.uRowStride,
      'vRowStride': req.vRowStride,
      'uPixelStride': req.uPixelStride,
      'vPixelStride': req.vPixelStride,
      'isBgra': req.isBgra,
      'rotationDegrees': req.rotationDegrees,
      'roiLeft': req.roiLeft,
      'roiTop': req.roiTop,
      'roiRight': req.roiRight,
      'roiBottom': req.roiBottom,
      'allowSsdFallback': req.allowSsdFallback,
    });

    return completer.future;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    final map = _pendingMap ?? _pending;
    for (final c in map.values) {
      if (!c.isCompleted) {
        c.completeError(StateError('Worker disposed'));
      }
    }
    map.clear();
    try {
      _sendPort.send({'type': 'dispose'});
    } catch (_) {}
    _subscription?.cancel();
    _receivePort.close();
    _isolate.kill(priority: Isolate.beforeNextEvent);
  }
}

void _workerEntryPoint(SendPort mainInitPort) {
  final workerReceive = ReceivePort();
  mainInitPort.send(workerReceive.sendPort);

  SendPort? replyPort;
  PlateDetectorService? detector;
  Uint8List? reusableSsdRgb;
  Uint8List? reusableWpodRgb;

  workerReceive.listen((message) {
    if (message is! Map) return;
    final type = message['type'];

    if (type == 'init') {
      replyPort = message['replyPort'] as SendPort;
      try {
        final ssdTtd = message['ssdBytes'] as TransferableTypedData;
        final ssdBytes = ssdTtd.materialize().asUint8List();
        final wpodTtd = message['wpodBytes'] as TransferableTypedData?;
        final wpodBytes = wpodTtd?.materialize().asUint8List();

        detector = PlateDetectorService.createFromBuffers(
          ssdModelBytes: ssdBytes,
          wpodModelBytes: wpodBytes,
        );
        reusableSsdRgb =
            Uint8List(detector!.ssdWidth * detector!.ssdHeight * 3);
        if (detector!.diagnostics.wpodLoaded) {
          reusableWpodRgb =
              Uint8List(detector!.wpodWidth * detector!.wpodHeight * 3);
        }

        replyPort!.send({
          'type': 'init_done',
          'diag': detector!.diagnostics,
        });
      } catch (e) {
        replyPort!.send({
          'type': 'init_error',
          'error': e.toString(),
        });
      }
      return;
    }

    if (type == 'dispose') {
      detector?.dispose();
      detector = null;
      workerReceive.close();
      return;
    }

    if (type == 'frame' && detector != null && replyPort != null) {
      final int frameId = message['frameId'] as int;
      try {
        final result = _runWorkerFrame(
          frameId: frameId,
          message: message,
          detector: detector!,
          ssdRgbBuf: reusableSsdRgb!,
          wpodRgbBuf: reusableWpodRgb,
        );
        replyPort!.send({
          'type': 'frame_result',
          'result': result,
        });
      } catch (e) {
        replyPort!.send({
          'type': 'frame_result',
          'result': WorkerFrameResult(
            frameId: frameId,
            detected: false,
            framePrepMs: 0,
            detectMs: 0,
            cropPreprocessMs: 0,
            detectConfidence: 0,
            skewAngleDeg: 0,
            usedPerspectiveWarp: false,
            usedContrastFix: false,
            usedSharpen: false,
            isTwoRowCandidate: false,
            error: e.toString(),
          ),
        });
      }
    }
  });
}

WorkerFrameResult _runWorkerFrame({
  required int frameId,
  required Map<dynamic, dynamic> message,
  required PlateDetectorService detector,
  required Uint8List ssdRgbBuf,
  required Uint8List? wpodRgbBuf,
}) {
  final prepSw = Stopwatch()..start();

  final Uint8List yOrBgra =
      (message['yOrBgra'] as TransferableTypedData).materialize().asUint8List();
  final uTtd = message['u'] as TransferableTypedData?;
  final vTtd = message['v'] as TransferableTypedData?;
  final Uint8List? uBytes = uTtd?.materialize().asUint8List();
  final Uint8List? vBytes = vTtd?.materialize().asUint8List();

  final int srcW = message['srcWidth'] as int;
  final int srcH = message['srcHeight'] as int;
  final int yStride = message['yRowStride'] as int;
  final int yPxStride = message['yPixelStride'] as int;
  final int uStride = message['uRowStride'] as int;
  final int vStride = message['vRowStride'] as int;
  final int uPxStride = message['uPixelStride'] as int;
  final int vPxStride = message['vPixelStride'] as int;
  final bool isBgra = message['isBgra'] as bool;
  final int rot = (((message['rotationDegrees'] as int) % 360) + 360) % 360;

  final double roiLeft = message['roiLeft'] as double;
  final double roiTop = message['roiTop'] as double;
  final double roiRight = message['roiRight'] as double;
  final double roiBottom = message['roiBottom'] as double;
  final bool allowSsdFallback = message['allowSsdFallback'] as bool? ?? true;

  final int dispW = (rot == 90 || rot == 270) ? srcH : srcW;
  final int dispH = (rot == 90 || rot == 270) ? srcW : srcH;

  int left = (roiLeft.clamp(0.0, 1.0) * dispW).floor();
  int top = (roiTop.clamp(0.0, 1.0) * dispH).floor();
  int right = (roiRight.clamp(0.0, 1.0) * dispW).ceil();
  int bottom = (roiBottom.clamp(0.0, 1.0) * dispH).ceil();

  int roiW = (right - left).clamp(32, dispW) & ~1;
  int roiH = (bottom - top).clamp(32, dispH) & ~1;
  if (roiW < 32) roiW = math.min(dispW & ~1, 32);
  if (roiH < 32) roiH = math.min(dispH & ~1, 32);
  if (left + roiW > dispW) left = math.max(0, dispW - roiW);
  if (top + roiH > dispH) top = math.max(0, dispH - roiH);

  // Fast-path prep: fill ONLY the 208x208 WPOD RGB tensor (~43K pixels)
  // directly from rotated camera planes — skip full-ROI grayscale copy unless
  // a plate is actually detected!
  if (wpodRgbBuf != null) {
    PlateImageProcessor.fillRgbFromCameraRoi(
      outRgb: wpodRgbBuf,
      dstW: detector.wpodWidth,
      dstH: detector.wpodHeight,
      yOrBgra: yOrBgra,
      uBytes: uBytes,
      vBytes: vBytes,
      srcW: srcW,
      srcH: srcH,
      yStride: yStride,
      yPxStride: yPxStride,
      uStride: uStride,
      vStride: vStride,
      uPxStride: uPxStride,
      vPxStride: vPxStride,
      isBgra: isBgra,
      rot: rot,
      roiLeft: left,
      roiTop: top,
      roiW: roiW,
      roiH: roiH,
    );
  } else {
    PlateImageProcessor.fillRgbFromCameraRoi(
      outRgb: ssdRgbBuf,
      dstW: detector.ssdWidth,
      dstH: detector.ssdHeight,
      yOrBgra: yOrBgra,
      uBytes: uBytes,
      vBytes: vBytes,
      srcW: srcW,
      srcH: srcH,
      yStride: yStride,
      yPxStride: yPxStride,
      uStride: uStride,
      vStride: vStride,
      uPxStride: uPxStride,
      vPxStride: vPxStride,
      isBgra: isBgra,
      rot: rot,
      roiLeft: left,
      roiTop: top,
      roiW: roiW,
      roiH: roiH,
    );
  }
  final int framePrepMs = prepSw.elapsedMilliseconds;

  // Stage 1: Fast primary WPOD-Net detection (~50ms GPU_V2) returning both box
  // & 4 affine corners. Fall back to SSD_320 only when WPOD misses and
  // allowSsdFallback is enabled (catches small/distant plates).
  final detSw = Stopwatch()..start();
  PlateDetectionBox? det;
  if (wpodRgbBuf != null) {
    det = detector.detectFastWithWpod(wpodRgbBuf, threshold: 0.72);
    if (det == null && allowSsdFallback) {
      PlateImageProcessor.fillRgbFromCameraRoi(
        outRgb: ssdRgbBuf,
        dstW: detector.ssdWidth,
        dstH: detector.ssdHeight,
        yOrBgra: yOrBgra,
        uBytes: uBytes,
        vBytes: vBytes,
        srcW: srcW,
        srcH: srcH,
        yStride: yStride,
        yPxStride: yPxStride,
        uStride: uStride,
        vStride: vStride,
        uPxStride: uPxStride,
        vPxStride: vPxStride,
        isBgra: isBgra,
        rot: rot,
        roiLeft: left,
        roiTop: top,
        roiW: roiW,
        roiH: roiH,
      );
      det = detector.detectWithSsd(ssdRgbBuf, minConfidence: 0.42);
    }
  } else {
    det = detector.detectWithSsd(ssdRgbBuf, minConfidence: 0.42);
  }
  final int detectMs = detSw.elapsedMilliseconds;

  if (det == null) {
    return WorkerFrameResult(
      frameId: frameId,
      detected: false,
      framePrepMs: framePrepMs,
      detectMs: detectMs,
      cropPreprocessMs: 0,
      detectConfidence: 0,
      skewAngleDeg: 0,
      usedPerspectiveWarp: false,
      usedContrastFix: false,
      usedSharpen: false,
      isTwoRowCandidate: false,
    );
  }

  // Stage 2: Extract ONLY the detected plate sub-region directly from raw
  // sensor memory (never touching pixels outside the plate!), warp, and apply
  // quality-adaptive enhancement.
  final cropSw = Stopwatch()..start();

  List<double> quadX;
  List<double> quadY;
  bool usedPerspective = false;
  double skewAngleDeg = 0.0;

  if (det.cornersX != null && det.cornersY != null) {
    final absX = det.cornersX!.map((nx) => left + nx * roiW).toList();
    final absY = det.cornersY!.map((ny) => top + ny * roiH).toList();
    final expanded = PlateImageProcessor.expandQuad(
      x: absX,
      y: absY,
      maxW: dispW,
      maxH: dispH,
      padXRatio: 0.10,
      padYRatio: 0.18,
    );
    quadX = expanded.x;
    quadY = expanded.y;
    usedPerspective = true;
    skewAngleDeg = math.atan2(
          quadY[1] - quadY[0],
          math.max(1.0, quadX[1] - quadX[0]),
        ) *
        180.0 /
        math.pi;
  } else {
    final double boxW = det.width * roiW;
    final double boxH = det.height * roiH;
    final double padX = math.max(8.0, boxW * 0.14);
    final double padY = math.max(8.0, boxH * 0.24);
    final int cLeft = (left + det.left * roiW - padX).floor().clamp(0, dispW - 8);
    final int cTop = (top + det.top * roiH - padY).floor().clamp(0, dispH - 8);
    final int cRight =
        (left + det.right * roiW + padX).ceil().clamp(cLeft + 8, dispW);
    final int cBottom =
        (top + det.bottom * roiH + padY).ceil().clamp(cTop + 8, dispH);

    final int cropW = cRight - cLeft;
    final int cropH = cBottom - cTop;

    // Fast Sobel projection skew check on only the small SSD crop.
    final cropGray = PlateImageProcessor.extractRotatedGray(
      srcBytes: yOrBgra,
      srcW: srcW,
      srcH: srcH,
      rowStride: yStride,
      pxStride: isBgra ? 4 : yPxStride,
      isBgra: isBgra,
      rot: rot,
      roiLeft: cLeft,
      roiTop: cTop,
      roiW: cropW,
      roiH: cropH,
    );
    skewAngleDeg = PlateImageProcessor.estimateSkewAngleDeg(
      cropGray,
      cropW,
      cropH,
    );
    if (skewAngleDeg.abs() >= 3.0) {
      final rotated = PlateImageProcessor.rotateRectQuad(
        cx: (cLeft + cRight) / 2.0,
        cy: (cTop + cBottom) / 2.0,
        w: cropW.toDouble(),
        h: cropH.toDouble(),
        angleDeg: skewAngleDeg,
        maxW: dispW,
        maxH: dispH,
      );
      quadX = rotated.x;
      quadY = rotated.y;
      usedPerspective = true;
    } else {
      quadX = [
        cLeft.toDouble(),
        cRight.toDouble(),
        cRight.toDouble(),
        cLeft.toDouble(),
      ];
      quadY = [
        cTop.toDouble(),
        cTop.toDouble(),
        cBottom.toDouble(),
        cBottom.toDouble(),
      ];
    }
  }

  // Perspective-warp directly from rotated sensor coordinates into a tight
  // upright plate crop (eliminating the full-ROI gray allocation).
  final warped = PlateImageProcessor.warpQuadFromSensorAndResize(
    srcBytes: yOrBgra,
    srcW: srcW,
    srcH: srcH,
    rowStride: yStride,
    pxStride: isBgra ? 4 : yPxStride,
    isBgra: isBgra,
    rot: rot,
    dispX: quadX,
    dispY: quadY,
  );

  final quality = PlateImageProcessor.measureQuality(
    warped.gray,
    warped.width,
    warped.height,
  );

  Uint8List processed = warped.gray;
  final bool doContrast = quality.needsBrightnessOrContrastFix;
  final bool doSharpen = quality.needsSharpening;

  if (doContrast) {
    processed = PlateImageProcessor.enhanceContrastAndBrightness(processed);
  }
  if (doSharpen) {
    final denoised = PlateImageProcessor.gaussianBlur3x3(
      processed,
      warped.width,
      warped.height,
    );
    processed = PlateImageProcessor.unsharpMask(
      processed,
      denoised,
      amount: 0.90,
    );
  }

  final Uint8List primaryNv21 = PlateImageProcessor.grayToNv21(
    processed,
    warped.width,
    warped.height,
  );

  // Prepare adaptive threshold only for severely low-contrast/uneven frames.
  Uint8List? adaptiveNv21;
  if (quality.contrastSpan < 70 || quality.meanBrightness < 80) {
    final bin = PlateImageProcessor.adaptiveThreshold(
      processed,
      warped.width,
      warped.height,
      radius: 9,
      cOffset: 9,
    );
    adaptiveNv21 =
        PlateImageProcessor.grayToNv21(bin, warped.width, warped.height);
  }

  final double aspect = warped.width / math.max(1, warped.height);
  final bool isTwoRow = aspect < 2.65 && warped.height >= 48;
  Uint8List? topRowNv21;
  int topRowW = 0;
  int topRowH = 0;
  Uint8List? bottomRowNv21;
  int bottomRowW = 0;
  int bottomRowH = 0;

  if (isTwoRow) {
    final int topH =
        ((warped.height * 0.56).round().clamp(16, warped.height)) & ~1;
    final int botStart =
        (warped.height * 0.42).floor().clamp(0, warped.height - 16);
    final int botH =
        ((warped.height - botStart).clamp(16, warped.height)) & ~1;

    if (topH >= 16 && botH >= 16) {
      final topGray = PlateImageProcessor.cropGraySubRect(
        processed,
        warped.width,
        0,
        0,
        warped.width,
        topH,
      );
      final botGray = PlateImageProcessor.cropGraySubRect(
        processed,
        warped.width,
        0,
        botStart,
        warped.width,
        botH,
      );
      topRowW = warped.width;
      topRowH = topH;
      bottomRowW = warped.width;
      bottomRowH = botH;
      topRowNv21 = PlateImageProcessor.grayToNv21(topGray, topRowW, topRowH);
      bottomRowNv21 =
          PlateImageProcessor.grayToNv21(botGray, bottomRowW, bottomRowH);
    }
  }

  return WorkerFrameResult(
    frameId: frameId,
    detected: true,
    framePrepMs: framePrepMs,
    detectMs: detectMs,
    cropPreprocessMs: cropSw.elapsedMilliseconds,
    detectConfidence: det.confidence,
    skewAngleDeg: skewAngleDeg,
    usedPerspectiveWarp: usedPerspective,
    usedContrastFix: doContrast,
    usedSharpen: doSharpen,
    isTwoRowCandidate: isTwoRow,
    detectorSource: det.source,
    primaryNv21: primaryNv21,
    primaryW: warped.width,
    primaryH: warped.height,
    adaptiveNv21: adaptiveNv21,
    topRowNv21: topRowNv21,
    topRowW: topRowW,
    topRowH: topRowH,
    bottomRowNv21: bottomRowNv21,
    bottomRowW: bottomRowW,
    bottomRowH: bottomRowH,
  );
}

class UprightGrayRoi {
  const UprightGrayRoi({
    required this.gray,
    required this.width,
    required this.height,
  });

  final Uint8List gray;
  final int width;
  final int height;
}

/// Pure-Dart image processing helpers for direct ROI sampling, TFLite RGB
/// tensor preparation, gradient-based skew detection, homography perspective
/// warp directly from rotated camera sensor bytes, and selective enhancement.
class PlateImageProcessor {
  PlateImageProcessor._();

  static Uint8List extractRotatedGray({
    required Uint8List srcBytes,
    required int srcW,
    required int srcH,
    required int rowStride,
    required int pxStride,
    required bool isBgra,
    required int rot,
    required int roiLeft,
    required int roiTop,
    required int roiW,
    required int roiH,
  }) {
    final out = Uint8List(roiW * roiH);
    int outIdx = 0;
    for (int dy = roiTop; dy < roiTop + roiH; dy++) {
      for (int dx = roiLeft; dx < roiLeft + roiW; dx++) {
        out[outIdx++] = _sampleSensorGray(
          srcBytes,
          srcW,
          srcH,
          rowStride,
          pxStride,
          isBgra,
          rot,
          dx,
          dy,
        );
      }
    }
    return out;
  }

  /// Directly warps the 4-corner quadrilateral `[dispX, dispY]` (in upright
  /// display coordinates) from raw camera sensor bytes into an upright,
  /// OCR-ready grayscale buffer without allocating a full-ROI intermediate.
  static UprightGrayRoi warpQuadFromSensorAndResize({
    required Uint8List srcBytes,
    required int srcW,
    required int srcH,
    required int rowStride,
    required int pxStride,
    required bool isBgra,
    required int rot,
    required List<double> dispX,
    required List<double> dispY,
  }) {
    final double topW = _dist(dispX[0], dispY[0], dispX[1], dispY[1]);
    final double botW = _dist(dispX[3], dispY[3], dispX[2], dispY[2]);
    final double leftH = _dist(dispX[0], dispY[0], dispX[3], dispY[3]);
    final double rightH = _dist(dispX[1], dispY[1], dispX[2], dispY[2]);

    final double targetW = math.max(16.0, math.max(topW, botW));
    final double targetH = math.max(16.0, math.max(leftH, rightH));

    // Scale small crops up to ~110px height (sweet spot for speed & ML Kit).
    double scale = 1.0;
    if (targetH < 110.0) {
      scale = 110.0 / targetH;
    }
    if (targetW * scale > 560.0) {
      scale = 560.0 / targetW;
    }
    if (targetH * scale > 280.0) {
      scale = math.min(scale, 280.0 / targetH);
    }

    int outW = ((targetW * scale).round()).clamp(24, 560) & ~1;
    int outH = ((targetH * scale).round()).clamp(24, 280) & ~1;
    if (outW < 24) outW = 24;
    if (outH < 24) outH = 24;

    final int dispW = (rot == 90 || rot == 270) ? srcH : srcW;
    final int dispH = (rot == 90 || rot == 270) ? srcW : srcH;

    final dstX = <double>[0.0, outW - 1.0, outW - 1.0, 0.0];
    final dstY = <double>[0.0, 0.0, outH - 1.0, outH - 1.0];
    final h = _solveHomography(dstX, dstY, dispX, dispY);

    final out = Uint8List(outW * outH);
    if (h == null) {
      final double minX = dispX.reduce(math.min);
      final double maxX = dispX.reduce(math.max);
      final double minY = dispY.reduce(math.min);
      final double maxY = dispY.reduce(math.max);
      final double spanX = math.max(1.0, maxX - minX);
      final double spanY = math.max(1.0, maxY - minY);
      int idx = 0;
      for (int y = 0; y < outH; y++) {
        final dy = (minY + (y / math.max(1, outH - 1)) * spanY)
            .round()
            .clamp(0, dispH - 1);
        for (int x = 0; x < outW; x++) {
          final dx = (minX + (x / math.max(1, outW - 1)) * spanX)
              .round()
              .clamp(0, dispW - 1);
          out[idx++] = _sampleSensorGray(
            srcBytes,
            srcW,
            srcH,
            rowStride,
            pxStride,
            isBgra,
            rot,
            dx,
            dy,
          );
        }
      }
      return UprightGrayRoi(gray: out, width: outW, height: outH);
    }

    final double h0 = h[0], h1 = h[1], h2 = h[2];
    final double h3 = h[3], h4 = h[4], h5 = h[5];
    final double h6 = h[6], h7 = h[7];

    int idx = 0;
    for (int y = 0; y < outH; y++) {
      final double dy = y.toDouble();
      final double rowX = h1 * dy + h2;
      final double rowY = h4 * dy + h5;
      final double rowW = h7 * dy + 1.0;
      for (int x = 0; x < outW; x++) {
        final double dx = x.toDouble();
        final double denom = h6 * dx + rowW;
        if (denom.abs() < 1e-6) {
          out[idx++] = 0;
          continue;
        }
        final double fx = ((h0 * dx + rowX) / denom).clamp(0.0, dispW - 1.0001);
        final double fy = ((h3 * dx + rowY) / denom).clamp(0.0, dispH - 1.0001);
        final int x0 = fx.floor();
        final int y0 = fy.floor();
        final int x1 = math.min(x0 + 1, dispW - 1);
        final int y1 = math.min(y0 + 1, dispH - 1);
        final double wx = fx - x0;
        final double wy = fy - y0;

        final int p00 = _sampleSensorGray(
          srcBytes,
          srcW,
          srcH,
          rowStride,
          pxStride,
          isBgra,
          rot,
          x0,
          y0,
        );
        final int p10 = _sampleSensorGray(
          srcBytes,
          srcW,
          srcH,
          rowStride,
          pxStride,
          isBgra,
          rot,
          x1,
          y0,
        );
        final int p01 = _sampleSensorGray(
          srcBytes,
          srcW,
          srcH,
          rowStride,
          pxStride,
          isBgra,
          rot,
          x0,
          y1,
        );
        final int p11 = _sampleSensorGray(
          srcBytes,
          srcW,
          srcH,
          rowStride,
          pxStride,
          isBgra,
          rot,
          x1,
          y1,
        );

        final double top = p00 * (1.0 - wx) + p10 * wx;
        final double bot = p01 * (1.0 - wx) + p11 * wx;
        out[idx++] = (top * (1.0 - wy) + bot * wy).round().clamp(0, 255);
      }
    }
    return UprightGrayRoi(gray: out, width: outW, height: outH);
  }

  static int _sampleSensorGray(
    Uint8List srcBytes,
    int srcW,
    int srcH,
    int rowStride,
    int pxStride,
    bool isBgra,
    int rot,
    int dx,
    int dy,
  ) {
    final int sx;
    final int sy;
    switch (rot) {
      case 90:
        sx = dy;
        sy = srcH - 1 - dx;
        break;
      case 180:
        sx = srcW - 1 - dx;
        sy = srcH - 1 - dy;
        break;
      case 270:
        sx = srcW - 1 - dy;
        sy = dx;
        break;
      default:
        sx = dx;
        sy = dy;
        break;
    }
    final int offset = sy * rowStride + sx * pxStride;
    if (isBgra) {
      if (offset + 2 < srcBytes.length) {
        return (77 * srcBytes[offset + 2] +
                150 * srcBytes[offset + 1] +
                29 * srcBytes[offset]) >>
            8;
      }
      return 0;
    }
    return offset < srcBytes.length ? srcBytes[offset] : 0;
  }

  static void fillRgbFromCameraRoi({
    required Uint8List outRgb,
    required int dstW,
    required int dstH,
    required Uint8List yOrBgra,
    required Uint8List? uBytes,
    required Uint8List? vBytes,
    required int srcW,
    required int srcH,
    required int yStride,
    required int yPxStride,
    required int uStride,
    required int vStride,
    required int uPxStride,
    required int vPxStride,
    required bool isBgra,
    required int rot,
    required int roiLeft,
    required int roiTop,
    required int roiW,
    required int roiH,
  }) {
    final bool hasChroma = !isBgra && uBytes != null && vBytes != null;
    int outIdx = 0;

    for (int y = 0; y < dstH; y++) {
      final int dy = roiTop + ((y * roiH) ~/ dstH);
      for (int x = 0; x < dstW; x++) {
        final int dx = roiLeft + ((x * roiW) ~/ dstW);
        final int sx;
        final int sy;
        switch (rot) {
          case 90:
            sx = dy;
            sy = srcH - 1 - dx;
            break;
          case 180:
            sx = srcW - 1 - dx;
            sy = srcH - 1 - dy;
            break;
          case 270:
            sx = srcW - 1 - dy;
            sy = dx;
            break;
          default:
            sx = dx;
            sy = dy;
            break;
        }

        if (isBgra) {
          final int off = sy * yStride + sx * 4;
          if (off + 2 < yOrBgra.length) {
            outRgb[outIdx++] = yOrBgra[off + 2];
            outRgb[outIdx++] = yOrBgra[off + 1];
            outRgb[outIdx++] = yOrBgra[off];
          } else {
            outRgb[outIdx++] = 0;
            outRgb[outIdx++] = 0;
            outRgb[outIdx++] = 0;
          }
        } else {
          final int yOff = sy * yStride + sx * yPxStride;
          final int yy = yOff < yOrBgra.length ? yOrBgra[yOff] : 0;
          if (hasChroma) {
            final int cx = sx >> 1;
            final int cy = sy >> 1;
            final int uOff = cy * uStride + cx * uPxStride;
            final int vOff = cy * vStride + cx * vPxStride;
            final int u = (uOff < uBytes.length ? uBytes[uOff] : 128) - 128;
            final int v = (vOff < vBytes.length ? vBytes[vOff] : 128) - 128;

            outRgb[outIdx++] = (yy + ((1436 * v) >> 10)).clamp(0, 255);
            outRgb[outIdx++] =
                (yy - ((352 * u + 731 * v) >> 10)).clamp(0, 255);
            outRgb[outIdx++] = (yy + ((1815 * u) >> 10)).clamp(0, 255);
          } else {
            outRgb[outIdx++] = yy;
            outRgb[outIdx++] = yy;
            outRgb[outIdx++] = yy;
          }
        }
      }
    }
  }

  static Uint8List cropGraySubRect(
    Uint8List src,
    int srcW,
    int left,
    int top,
    int w,
    int h,
  ) {
    final out = Uint8List(w * h);
    for (int row = 0; row < h; row++) {
      final int srcStart = (top + row) * srcW + left;
      final int dstStart = row * w;
      if (srcStart + w <= src.length) {
        out.setRange(dstStart, dstStart + w, src, srcStart);
      }
    }
    return out;
  }

  static Uint8List grayToNv21(Uint8List gray, int width, int height) {
    final int ySize = width * height;
    final int uvSize = ySize ~/ 2;
    final Uint8List nv21 = Uint8List(ySize + uvSize);
    nv21.setRange(0, ySize, gray);
    nv21.fillRange(ySize, nv21.length, 0x80);
    return nv21;
  }

  static double estimateSkewAngleDeg(Uint8List gray, int w, int h) {
    if (w < 24 || h < 16) return 0.0;
    const int sw = 56;
    const int sh = 28;
    final edge = Float32List(sw * sh);
    for (int y = 1; y < sh - 1; y++) {
      final int sy = (y * h) ~/ sh;
      for (int x = 1; x < sw - 1; x++) {
        final int sx = (x * w) ~/ sw;
        final int idx = sy * w + sx;
        final int gx = (gray[idx + 1] - gray[idx - 1]).abs();
        final int gy = (gray[idx + w] - gray[idx - w]).abs();
        edge[y * sw + x] = (gx + gy).toDouble();
      }
    }

    double bestAngle = 0.0;
    double bestScore = -1.0;
    const int cx = sw ~/ 2;

    for (int deg = -18; deg <= 18; deg += 3) {
      final double rad = deg * math.pi / 180.0;
      final double tanA = math.tan(rad);
      final rowSums = Float64List(sh);
      for (int y = 1; y < sh - 1; y++) {
        for (int x = 1; x < sw - 1; x++) {
          final int ry = (y - ((x - cx) * tanA)).round();
          if (ry >= 0 && ry < sh) {
            rowSums[ry] += edge[y * sw + x];
          }
        }
      }
      double sumSq = 0;
      for (int i = 0; i < sh; i++) {
        sumSq += rowSums[i] * rowSums[i];
      }
      final double penalty = deg == 0 ? 1.04 : 1.0;
      final double score = sumSq * penalty;
      if (score > bestScore) {
        bestScore = score;
        bestAngle = deg.toDouble();
      }
    }
    return bestAngle;
  }

  static ({List<double> x, List<double> y}) rotateRectQuad({
    required double cx,
    required double cy,
    required double w,
    required double h,
    required double angleDeg,
    required int maxW,
    required int maxH,
  }) {
    final double hw = w / 2.0;
    final double hh = h / 2.0;
    final double rad = angleDeg * math.pi / 180.0;
    final double cosA = math.cos(rad);
    final double sinA = math.sin(rad);

    const offsets = [
      (-1.0, -1.0),
      (1.0, -1.0),
      (1.0, 1.0),
      (-1.0, 1.0),
    ];
    final xs = <double>[];
    final ys = <double>[];
    for (final (ox, oy) in offsets) {
      final lx = ox * hw;
      final ly = oy * hh;
      xs.add((cx + lx * cosA - ly * sinA).clamp(0.0, maxW - 1.0));
      ys.add((cy + lx * sinA + ly * cosA).clamp(0.0, maxH - 1.0));
    }
    return (x: xs, y: ys);
  }

  static ({List<double> x, List<double> y}) expandQuad({
    required List<double> x,
    required List<double> y,
    required int maxW,
    required int maxH,
    double padXRatio = 0.12,
    double padYRatio = 0.20,
  }) {
    final double uxTop = x[1] - x[0];
    final double uyTop = y[1] - y[0];
    final double uxBot = x[2] - x[3];
    final double uyBot = y[2] - y[3];

    final double vxLeft = x[3] - x[0];
    final double vyLeft = y[3] - y[0];
    final double vxRight = x[2] - x[1];
    final double vyRight = y[2] - y[1];

    return (
      x: <double>[
        (x[0] - uxTop * padXRatio - vxLeft * padYRatio).clamp(0.0, maxW - 1.0),
        (x[1] + uxTop * padXRatio - vxRight * padYRatio).clamp(0.0, maxW - 1.0),
        (x[2] + uxBot * padXRatio + vxRight * padYRatio).clamp(0.0, maxW - 1.0),
        (x[3] - uxBot * padXRatio + vxLeft * padYRatio).clamp(0.0, maxW - 1.0),
      ],
      y: <double>[
        (y[0] - uyTop * padXRatio - vyLeft * padYRatio).clamp(0.0, maxH - 1.0),
        (y[1] + uyTop * padXRatio - vyRight * padYRatio).clamp(0.0, maxH - 1.0),
        (y[2] + uyBot * padXRatio + vyRight * padYRatio).clamp(0.0, maxH - 1.0),
        (y[3] - uyBot * padXRatio + vyLeft * padYRatio).clamp(0.0, maxH - 1.0),
      ],
    );
  }

  static PlateQualityMetrics measureQuality(Uint8List gray, int w, int h) {
    final len = gray.length;
    if (len == 0 || w < 3 || h < 3) {
      return const PlateQualityMetrics(
        meanBrightness: 128,
        contrastSpan: 128,
        sharpness: 200,
      );
    }
    final hist = Int32List(256);
    int sum = 0;
    for (int i = 0; i < len; i++) {
      final v = gray[i];
      hist[v]++;
      sum += v;
    }
    final int lowTarget = (len * 0.02).floor();
    final int highTarget = (len * 0.98).ceil();
    int cum = 0;
    int pLow = 0;
    for (int v = 0; v < 256; v++) {
      cum += hist[v];
      if (cum >= lowTarget) {
        pLow = v;
        break;
      }
    }
    cum = 0;
    int pHigh = 255;
    for (int v = 0; v < 256; v++) {
      cum += hist[v];
      if (cum >= highTarget) {
        pHigh = v;
        break;
      }
    }

    double lapSum = 0;
    double lapSqSum = 0;
    int lapCount = 0;
    for (int y = 1; y < h - 1; y += 2) {
      final int r = y * w;
      for (int x = 1; x < w - 1; x += 2) {
        final int idx = r + x;
        final int lap = gray[idx - w] +
            gray[idx + w] +
            gray[idx - 1] +
            gray[idx + 1] -
            4 * gray[idx];
        lapSum += lap;
        lapSqSum += lap * lap;
        lapCount++;
      }
    }
    final double meanLap = lapCount > 0 ? lapSum / lapCount : 0;
    final double variance =
        lapCount > 0 ? (lapSqSum / lapCount) - meanLap * meanLap : 200;

    return PlateQualityMetrics(
      meanBrightness: sum / len,
      contrastSpan: pHigh - pLow,
      sharpness: math.max(0.0, variance),
    );
  }

  static Uint8List enhanceContrastAndBrightness(Uint8List gray) {
    final int len = gray.length;
    if (len == 0) return gray;
    final hist = Int32List(256);
    int sum = 0;
    for (int i = 0; i < len; i++) {
      final v = gray[i];
      hist[v]++;
      sum += v;
    }
    final int lowTarget = (len * 0.02).floor();
    final int highTarget = (len * 0.98).ceil();
    int cum = 0;
    int pLow = 0;
    for (int v = 0; v < 256; v++) {
      cum += hist[v];
      if (cum >= lowTarget) {
        pLow = v;
        break;
      }
    }
    cum = 0;
    int pHigh = 255;
    for (int v = 0; v < 256; v++) {
      cum += hist[v];
      if (cum >= highTarget) {
        pHigh = v;
        break;
      }
    }
    final int span = math.max(16, pHigh - pLow);
    final double mean = sum / len;
    final double gamma = mean < 75
        ? 0.65
        : (mean < 105 ? 0.80 : (mean > 205 ? 1.15 : 1.0));

    final lut = Uint8List(256);
    for (int v = 0; v < 256; v++) {
      double norm = ((v - pLow) / span).clamp(0.0, 1.0);
      if (gamma != 1.0) {
        norm = math.pow(norm, gamma).toDouble();
      }
      lut[v] = (norm * 255.0).round().clamp(0, 255);
    }

    final out = Uint8List(len);
    for (int i = 0; i < len; i++) {
      out[i] = lut[gray[i]];
    }
    return out;
  }

  static Uint8List gaussianBlur3x3(Uint8List src, int w, int h) {
    final out = Uint8List(src.length);
    if (w < 3 || h < 3) {
      out.setAll(0, src);
      return out;
    }
    for (int y = 0; y < h; y++) {
      final int ym = y > 0 ? y - 1 : 0;
      final int yp = y + 1 < h ? y + 1 : h - 1;
      final int r0 = ym * w;
      final int r1 = y * w;
      final int r2 = yp * w;
      for (int x = 0; x < w; x++) {
        final int xm = x > 0 ? x - 1 : 0;
        final int xp = x + 1 < w ? x + 1 : w - 1;
        final int sum = src[r0 + xm] +
            2 * src[r0 + x] +
            src[r0 + xp] +
            2 * src[r1 + xm] +
            4 * src[r1 + x] +
            2 * src[r1 + xp] +
            src[r2 + xm] +
            2 * src[r2 + x] +
            src[r2 + xp];
        out[r1 + x] = sum >> 4;
      }
    }
    return out;
  }

  static Uint8List unsharpMask(
    Uint8List orig,
    Uint8List blurred, {
    double amount = 0.9,
  }) {
    final out = Uint8List(orig.length);
    for (int i = 0; i < orig.length; i++) {
      final int detail = orig[i] - blurred[i];
      out[i] = (orig[i] + amount * detail).round().clamp(0, 255);
    }
    return out;
  }

  static Uint8List adaptiveThreshold(
    Uint8List src,
    int w,
    int h, {
    int radius = 9,
    int cOffset = 9,
  }) {
    final int stride = w + 1;
    final integral = Int32List((h + 1) * stride);
    for (int y = 0; y < h; y++) {
      int rowSum = 0;
      final int srcRow = y * w;
      final int prevRow = y * stride;
      final int curRow = (y + 1) * stride;
      for (int x = 0; x < w; x++) {
        rowSum += src[srcRow + x];
        integral[curRow + x + 1] = integral[prevRow + x + 1] + rowSum;
      }
    }
    final out = Uint8List(src.length);
    for (int y = 0; y < h; y++) {
      final int y0 = math.max(0, y - radius);
      final int y1 = math.min(h - 1, y + radius);
      final int r0 = y0 * stride;
      final int r1 = (y1 + 1) * stride;
      final int srcRow = y * w;
      for (int x = 0; x < w; x++) {
        final int x0 = math.max(0, x - radius);
        final int x1 = math.min(w - 1, x + radius);
        final int count = (x1 - x0 + 1) * (y1 - y0 + 1);
        final int areaSum = integral[r1 + x1 + 1] -
            integral[r0 + x1 + 1] -
            integral[r1 + x0] +
            integral[r0 + x0];
        final int localMean = areaSum ~/ count;
        out[srcRow + x] = src[srcRow + x] < (localMean - cOffset) ? 20 : 245;
      }
    }
    return out;
  }

  static double _dist(double x1, double y1, double x2, double y2) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    return math.sqrt(dx * dx + dy * dy);
  }

  static List<double>? _solveHomography(
    List<double> sx,
    List<double> sy,
    List<double> dx,
    List<double> dy,
  ) {
    final a = List<List<double>>.generate(8, (_) => List<double>.filled(9, 0));
    for (int i = 0; i < 4; i++) {
      final double x = sx[i];
      final double y = sy[i];
      final double u = dx[i];
      final double v = dy[i];

      final int r1 = 2 * i;
      a[r1][0] = x;
      a[r1][1] = y;
      a[r1][2] = 1;
      a[r1][6] = -u * x;
      a[r1][7] = -u * y;
      a[r1][8] = u;

      final int r2 = r1 + 1;
      a[r2][3] = x;
      a[r2][4] = y;
      a[r2][5] = 1;
      a[r2][6] = -v * x;
      a[r2][7] = -v * y;
      a[r2][8] = v;
    }

    for (int col = 0; col < 8; col++) {
      int pivot = col;
      double maxVal = a[col][col].abs();
      for (int row = col + 1; row < 8; row++) {
        final val = a[row][col].abs();
        if (val > maxVal) {
          maxVal = val;
          pivot = row;
        }
      }
      if (maxVal < 1e-8) return null;
      if (pivot != col) {
        final tmp = a[col];
        a[col] = a[pivot];
        a[pivot] = tmp;
      }

      final double div = a[col][col];
      for (int j = col; j < 9; j++) {
        a[col][j] /= div;
      }

      for (int row = 0; row < 8; row++) {
        if (row == col) continue;
        final double factor = a[row][col];
        if (factor == 0) continue;
        for (int j = col; j < 9; j++) {
          a[row][j] -= factor * a[col][j];
        }
      }
    }

    return List<double>.generate(8, (i) => a[i][8]);
  }
}
