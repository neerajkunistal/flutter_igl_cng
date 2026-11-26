import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Output of the dedicated TFLite license plate detector.
class PlateDetectionBox {
  const PlateDetectionBox({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.confidence,
    this.cornersX,
    this.cornersY,
    this.source = 'wpod',
  });

  /// Normalized `[0..1]` box in the ROI passed to the detector.
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double confidence;
  final String source;

  /// Optional 4 perspective corners `[TL, TR, BR, BL]` in normalized `[0..1]`.
  final List<double>? cornersX;
  final List<double>? cornersY;

  double get width => math.max(0.0, right - left);
  double get height => math.max(0.0, bottom - top);
  double get aspectRatio => height > 0 ? width / height : 0.0;
}

class DetectorDiagnostics {
  const DetectorDiagnostics({
    required this.delegateName,
    required this.wpodDelegateName,
    required this.ssdWidth,
    required this.ssdHeight,
    required this.ssdIsFloat,
    required this.wpodWidth,
    required this.wpodHeight,
    required this.wpodLoaded,
    required this.initMs,
  });

  final String delegateName;
  final String wpodDelegateName;
  final int ssdWidth;
  final int ssdHeight;
  final bool ssdIsFloat;
  final int wpodWidth;
  final int wpodHeight;
  final bool wpodLoaded;
  final int initMs;
}

/// Manages cached TFLite interpreters inside the persistent worker Isolate:
/// - Primary fast detector: `wpod_net.tflite` (208x208, ~50ms on GPU_V2) which
///   outputs both bounding region AND 4 affine perspective corners in one pass.
/// - Fallback wide/small-plate detector: `plate_detector.tflite` (SSD 320x320)
///   when WPOD misses distant or off-scale plates.
///
/// Uses Android `GpuDelegateV2` when supported and safe multi-threaded CPU
/// (`threads = 4`, LiteRT built-in XNNPACK) fallback without calling the unsafe
/// manual `XNNPackDelegateOptions` FFI wrapper.
class PlateDetectorService {
  PlateDetectorService({
    required this.ssdInterpreter,
    required this.wpodInterpreter,
    required this.delegates,
    required this.diagnostics,
  })  : _ssdW = diagnostics.ssdWidth,
        _ssdH = diagnostics.ssdHeight,
        _ssdIsFloat = diagnostics.ssdIsFloat,
        _wpodW = diagnostics.wpodWidth,
        _wpodH = diagnostics.wpodHeight {
    final ssdCount = _ssdW * _ssdH * 3;
    if (_ssdIsFloat) {
      _ssdFloatInput = Float32List(ssdCount);
    } else {
      _ssdUint8Input = Uint8List(ssdCount);
    }
    if (wpodInterpreter != null) {
      _wpodFloatInput = Float32List(_wpodW * _wpodH * 3);
    }
  }

  final Interpreter ssdInterpreter;
  final Interpreter? wpodInterpreter;
  final List<Delegate> delegates;
  final DetectorDiagnostics diagnostics;

  final int _ssdW;
  final int _ssdH;
  final bool _ssdIsFloat;
  Float32List? _ssdFloatInput;
  Uint8List? _ssdUint8Input;

  final int _wpodW;
  final int _wpodH;
  Float32List? _wpodFloatInput;

  bool _disposed = false;

  int get ssdWidth => _ssdW;
  int get ssdHeight => _ssdH;
  int get wpodWidth => _wpodW;
  int get wpodHeight => _wpodH;

  static ({Interpreter interpreter, Delegate? delegate, String name})
      _createInterpreter(Uint8List modelBytes) {
    if (Platform.isAndroid) {
      try {
        final gpu = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: true,
          ),
        );
        final opts = InterpreterOptions()..addDelegate(gpu);
        final interp = Interpreter.fromBuffer(modelBytes, options: opts);
        return (interpreter: interp, delegate: gpu, name: 'GPU_V2');
      } catch (e) {
        debugPrint('PlateDetectorService: GPU delegate unavailable ($e)');
      }
    }

    // LiteRT 1.4.0 enables XNNPACK internally with threads=4 safely on 32-bit
    // and 64-bit ARM without manual XNNPackDelegateOptions struct issues.
    final opts = InterpreterOptions()..threads = 4;
    final interp = Interpreter.fromBuffer(modelBytes, options: opts);
    return (interpreter: interp, delegate: null, name: 'CPU_4T');
  }

  static PlateDetectorService createFromBuffers({
    required Uint8List ssdModelBytes,
    Uint8List? wpodModelBytes,
  }) {
    final sw = Stopwatch()..start();
    final delegates = <Delegate>[];

    final ssdRes = _createInterpreter(ssdModelBytes);
    if (ssdRes.delegate != null) delegates.add(ssdRes.delegate!);

    Interpreter? wpod;
    String wpodName = 'NONE';
    if (wpodModelBytes != null && wpodModelBytes.isNotEmpty) {
      try {
        final wpodRes = _createInterpreter(wpodModelBytes);
        wpod = wpodRes.interpreter;
        wpodName = wpodRes.name;
        if (wpodRes.delegate != null) delegates.add(wpodRes.delegate!);
      } catch (e) {
        debugPrint('PlateDetectorService: WPOD-Net load failed ($e)');
      }
    }

    final ssdShape = ssdRes.interpreter.getInputTensor(0).shape;
    final ssdH = ssdShape.length >= 3 ? ssdShape[1] : 320;
    final ssdW = ssdShape.length >= 3 ? ssdShape[2] : 320;
    final ssdIsFloat =
        ssdRes.interpreter.getInputTensor(0).type == TensorType.float32;

    int wpodW = 208;
    int wpodH = 208;
    if (wpod != null) {
      final wShape = wpod.getInputTensor(0).shape;
      wpodH = wShape.length >= 3 ? wShape[1] : 208;
      wpodW = wShape.length >= 3 ? wShape[2] : 208;
    }

    final diag = DetectorDiagnostics(
      delegateName: ssdRes.name,
      wpodDelegateName: wpodName,
      ssdWidth: ssdW,
      ssdHeight: ssdH,
      ssdIsFloat: ssdIsFloat,
      wpodWidth: wpodW,
      wpodHeight: wpodH,
      wpodLoaded: wpod != null,
      initMs: sw.elapsedMilliseconds,
    );

    return PlateDetectorService(
      ssdInterpreter: ssdRes.interpreter,
      wpodInterpreter: wpod,
      delegates: delegates,
      diagnostics: diag,
    );
  }

  /// Fast primary WPOD-Net detection (`208x208`) returning both bounding box
  /// and 4 perspective corners `[TL, TR, BR, BL]` in a single pass.
  PlateDetectionBox? detectFastWithWpod(
    Uint8List rgb0to255, {
    double threshold = 0.72,
  }) {
    final corners = refineCornersWithWpod(rgb0to255, threshold: threshold);
    if (corners == null) return null;

    final double minX = corners.x.reduce(math.min);
    final double maxX = corners.x.reduce(math.max);
    final double minY = corners.y.reduce(math.min);
    final double maxY = corners.y.reduce(math.max);
    if (maxX - minX < 0.08 || maxY - minY < 0.04) return null;

    return PlateDetectionBox(
      left: minX,
      top: minY,
      right: maxX,
      bottom: maxY,
      confidence: corners.confidence,
      cornersX: corners.x,
      cornersY: corners.y,
      source: 'wpod',
    );
  }

  /// Runs SSD MobileNet (`320x320`) license plate detection on RGB bytes.
  PlateDetectionBox? detectWithSsd(
    Uint8List rgb0to255, {
    double minConfidence = 0.42,
  }) {
    if (_disposed) return null;

    final inTensor = ssdInterpreter.getInputTensor(0);
    if (_ssdIsFloat) {
      final buf = _ssdFloatInput!;
      final len = math.min(buf.length, rgb0to255.length);
      for (int i = 0; i < len; i++) {
        buf[i] = (rgb0to255[i] - 127.5) / 127.5;
      }
      inTensor.data = buf.buffer.asUint8List();
    } else {
      final buf = _ssdUint8Input!;
      final len = math.min(buf.length, rgb0to255.length);
      buf.setRange(0, len, rgb0to255);
      inTensor.data = buf;
    }

    ssdInterpreter.invoke();

    final outputs = ssdInterpreter.getOutputTensors();
    Float32List? boxesFlat;
    int maxDetections = 0;
    final vectorOutputs = <Float32List>[];

    for (final t in outputs) {
      final s = t.shape;
      if (s.length == 3 && s[2] == 4) {
        maxDetections = s[1];
        boxesFlat = _readFloatList(t);
      } else if (s.length == 2 && s[0] == 1 && s[1] > 1) {
        vectorOutputs.add(_readFloatList(t));
      }
    }

    if (boxesFlat == null || maxDetections == 0 || vectorOutputs.isEmpty) {
      return null;
    }

    final Float32List scoresFlat = vectorOutputs.length >= 2
        ? _pickScoresTensor(vectorOutputs)
        : vectorOutputs.first;

    double bestScore = -1.0;
    int bestIdx = -1;
    final int count = math.min(maxDetections, scoresFlat.length);
    for (int i = 0; i < count; i++) {
      final double score = scoresFlat[i];
      if (score >= minConfidence && score <= 1.0 && score > bestScore) {
        final base = i * 4;
        final double ymin = boxesFlat[base];
        final double xmin = boxesFlat[base + 1];
        final double ymax = boxesFlat[base + 2];
        final double xmax = boxesFlat[base + 3];
        if (xmax > xmin + 0.03 && ymax > ymin + 0.02) {
          bestScore = score;
          bestIdx = i;
        }
      }
    }

    if (bestIdx < 0) return null;

    final base = bestIdx * 4;
    return PlateDetectionBox(
      left: boxesFlat[base].clamp(0.0, 1.0),
      top: boxesFlat[base + 1].clamp(0.0, 1.0),
      right: boxesFlat[base + 2].clamp(0.0, 1.0),
      bottom: boxesFlat[base + 3].clamp(0.0, 1.0),
      confidence: bestScore,
      source: 'ssd',
    );
  }

  /// Runs WPOD-Net (`208x208x3`, `[0..1]`) to extract 4 perspective corners
  /// `[TL, TR, BR, BL]` normalized to `[0..1]` within the input image.
  ({List<double> x, List<double> y, double confidence})? refineCornersWithWpod(
    Uint8List rgb0to255, {
    double threshold = 0.68,
  }) {
    final wpod = wpodInterpreter;
    final buf = _wpodFloatInput;
    if (_disposed || wpod == null || buf == null) return null;

    final len = math.min(buf.length, rgb0to255.length);
    for (int i = 0; i < len; i++) {
      buf[i] = rgb0to255[i] / 255.0;
    }

    final inTensor = wpod.getInputTensor(0);
    if (inTensor.type == TensorType.float32) {
      inTensor.data = buf.buffer.asUint8List();
    } else {
      inTensor.data = rgb0to255;
    }

    wpod.invoke();

    final outTensor = wpod.getOutputTensor(0);
    final outShape = outTensor.shape;
    if (outShape.length != 4 || outShape[3] < 8) return null;

    final int gridH = outShape[1];
    final int gridW = outShape[2];
    final int channels = outShape[3];
    final Float32List outData = _readFloatList(outTensor);

    double maxProb = -1.0;
    int bestGy = -1;
    int bestGx = -1;
    for (int gy = 0; gy < gridH; gy++) {
      for (int gx = 0; gx < gridW; gx++) {
        final idx = (gy * gridW + gx) * channels;
        final double prob = outData[idx];
        if (prob >= threshold && prob > maxProb) {
          maxProb = prob;
          bestGy = gy;
          bestGx = gx;
        }
      }
    }
    if (bestGy < 0) return null;

    const double netStride = 16.0;
    const double side = ((208.0 + 40.0) / 2.0) / netStride; // 7.75
    final double mnW = _wpodW / netStride;
    final double mnH = _wpodH / netStride;

    final int base = (bestGy * gridW + bestGx) * channels;
    final double a00 = math.max(0.0, outData[base + 2]);
    final double a01 = outData[base + 3];
    final double a02 = outData[base + 4];
    final double a10 = outData[base + 5];
    final double a11 = math.max(0.0, outData[base + 6]);
    final double a12 = outData[base + 7];

    const vx = [-0.5, 0.5, 0.5, -0.5];
    const vy = [-0.5, -0.5, 0.5, 0.5];
    final double cx = bestGx + 0.5;
    final double cy = bestGy + 0.5;

    final xs = <double>[];
    final ys = <double>[];
    for (int k = 0; k < 4; k++) {
      final double px = (a00 * vx[k] + a01 * vy[k] + a02) * side + cx;
      final double py = (a10 * vx[k] + a11 * vy[k] + a12) * side + cy;
      xs.add((px / mnW).clamp(0.0, 1.0));
      ys.add((py / mnH).clamp(0.0, 1.0));
    }

    final double wTop = (xs[1] - xs[0]).abs();
    final double hLeft = (ys[3] - ys[0]).abs();
    if (wTop < 0.08 || hLeft < 0.04) return null;

    return (x: xs, y: ys, confidence: maxProb);
  }

  Float32List _readFloatList(Tensor tensor) {
    final bytes = tensor.data;
    final bd = ByteData.sublistView(bytes);
    final count = bytes.lengthInBytes ~/ 4;
    final out = Float32List(count);
    for (int i = 0; i < count; i++) {
      out[i] = bd.getFloat32(i * 4, Endian.host);
    }
    return out;
  }

  Float32List _pickScoresTensor(List<Float32List> candidates) {
    for (final c in candidates) {
      bool hasFraction = false;
      bool validRange = true;
      for (int i = 0; i < math.min(10, c.length); i++) {
        final v = c[i];
        if (v < 0.0 || v > 1.0) {
          validRange = false;
          break;
        }
        if (v > 0.0 && v < 1.0) {
          hasFraction = true;
        }
      }
      if (validRange && hasFraction) return c;
    }
    return candidates.first;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    try {
      ssdInterpreter.close();
    } catch (_) {}
    try {
      wpodInterpreter?.close();
    } catch (_) {}
    for (final d in delegates) {
      try {
        d.delete();
      } catch (_) {}
    }
  }
}
