import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/helper/indian_plate_validator.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/helper/plate_image_processor.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/screens/vehicle_loading_screen.dart';
import 'package:flutter_igl_cng/feature/numberPlateScanner/services/vehicle_api_service.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:indian_number_plate_ocr/indian_number_plate_ocr.dart';
import 'package:permission_handler/permission_handler.dart';

/// Screen states. Camera preview is visible in [scanning] / [paused].
enum _ScannerStatus {
  initializing,
  scanning,
  paused,
  permissionDenied,
  permissionBlocked,
  error,
}

class _HudStatus {
  const _HudStatus({
    required this.message,
    this.isRetrying = false,
    this.isActiveWork = false,
    this.uncertainCandidate,
  });

  final String message;
  final bool isRetrying;
  final bool isActiveWork;
  final String? uncertainCandidate;

  @override
  bool operator ==(Object other) =>
      other is _HudStatus &&
      other.message == message &&
      other.isRetrying == isRetrying &&
      other.isActiveWork == isActiveWork &&
      other.uncertainCandidate == uncertainCandidate;

  @override
  int get hashCode =>
      Object.hash(message, isRetrying, isActiveWork, uncertainCandidate);
}

class _FrameObservation {
  const _FrameObservation({
    required this.plate,
    required this.confidence,
    required this.timestamp,
  });

  final String plate;
  final double confidence;
  final DateTime timestamp;
}

/// Live, fully automatic Indian ANPR Scanner.
///
/// Pipeline (no capture button):
///   camera stream (140ms throttle) -> persistent Worker Isolate (TFLite plate
///   detector + GPU/XNNPACK + WPOD/Sobel skew & perspective warp + quality-
///   adaptive enhancement) -> ML Kit TextRecognizer (only on detected plate
///   crop, with explicit 2-row splitting) -> `indian_number_plate_ocr` +
///   strict validation + confidence voting -> AlertDialog (or manual verify
///   option for uncertain detections).
class NumberPlateScannerPage extends StatefulWidget {
  const NumberPlateScannerPage({super.key});

  @override
  State<NumberPlateScannerPage> createState() => _NumberPlateScannerPageState();
}

class _NumberPlateScannerPageState extends State<NumberPlateScannerPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  // ---- Assets & Tuning ----------------------------------------------------

  static const String _ssdModelAsset = 'assets/models/plate_detector.tflite';
  static const String _wpodModelAsset = 'assets/models/wpod_net.tflite';

  static const Duration _frameInterval = Duration(milliseconds: 100);
  static const Duration _confirmWindow = Duration(milliseconds: 2200);
  static const double _instantConfirmDetectConf = 0.55;
  static const double _instantConfirmOcrConf = 0.80;
  static const Duration _recentCacheTtl = Duration(seconds: 30);
  static const int _fallbackVoteFrames = 2;

  static const Duration _permissionTimeout = Duration(seconds: 15);
  static const Duration _cameraListTimeout = Duration(seconds: 8);
  static const Duration _cameraInitTimeout = Duration(seconds: 10);
  static const Duration _streamStartTimeout = Duration(seconds: 5);
  static const Duration _workerTimeout = Duration(milliseconds: 1800);
  static const Duration _ocrTimeout = Duration(milliseconds: 2200);
  static const Duration _processingWatchdogTimeout = Duration(seconds: 4);

  static const int _recreateRecognizerThreshold = 6;
  static const int _maxConsecutiveFailures = 14;

  static const Map<DeviceOrientation, int> _deviceOrientationDegrees = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  // ---- Services (cached across scans) -------------------------------------

  final IndianPlateOcrService _plateService = IndianPlateOcrService();
  final VehicleApiService _vehicleApiService = VehicleApiService();
  TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  PlateWorkerSession? _worker;
  Future<void>? _workerInitFuture;

  // ---- Camera state -------------------------------------------------------

  CameraController? _controller;
  CameraDescription? _camera;

  int _sessionId = 0;
  int _scanGeneration = 0;
  int _frameSeq = 0;

  late final AnimationController _scanLineController;

  // ---- UI state -----------------------------------------------------------

  _ScannerStatus _status = _ScannerStatus.initializing;
  String? _errorMessage;
  String? _detectedPlate;
  bool _torchOn = false;
  bool _torchSupported = true;
  Size? _viewportSize;

  final ValueNotifier<_HudStatus> _hudStatus = ValueNotifier(
    const _HudStatus(message: 'Initializing Camera...', isActiveWork: true),
  );

  // ---- Detection / Voting / Lock state ------------------------------------

  bool _isProcessingFrame = false;
  DateTime? _processingStartedAt;
  bool _isDialogShowing = false;
  bool _isApiRequestInFlight = false;
  String? _lastApiVehicleNumber;
  DateTime? _lastApiRequestedAt;
  DateTime _lastProcessedAt = DateTime.fromMillisecondsSinceEpoch(0);

  int _consecutiveFailures = 0;
  int _failedFramesTotal = 0;
  bool _didResetRecognizerInBurst = false;
  int? _lastFrameSampleHash;
  int _skippedSameHashCount = 0;

  final List<_FrameObservation> _observations = <_FrameObservation>[];
  final Map<String, DateTime> _recentResultsCache = <String, DateTime>{};
  final Map<String, int> _uncertainHits = <String, int>{};
  String? _bestUncertainCandidate;
  int _detectedWithoutConfirmCount = 0;
  DateTime? _firstDetectedWithoutConfirmAt;
  int _consecutiveWpodMisses = 0;

  // ---- Lifecycle bookkeeping ---------------------------------------------

  bool _wasBackgrounded = false;
  bool _resumeInPausedState = false;
  bool _isRecoveringCamera = false;

  // =========================================================================
  // Widget lifecycle
  // =========================================================================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _workerInitFuture = _ensureWorkerInitialized();
    unawaited(_initialize());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionId++;
    _scanGeneration++;
    _scanLineController.dispose();
    _hudStatus.dispose();
    unawaited(_releaseCamera());
    unawaited(_textRecognizer.close());
    _worker?.dispose();
    _worker = null;
    _plateService.dispose();
    _vehicleApiService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        if (!_wasBackgrounded) {
          _wasBackgrounded = true;
          _resumeInPausedState =
              _status == _ScannerStatus.paused || _isDialogShowing;
        }
        _sessionId++;
        _scanGeneration++;
        _isProcessingFrame = false;
        _processingStartedAt = null;
        unawaited(_releaseCamera());
        _setStatus(_ScannerStatus.initializing);
        break;
      case AppLifecycleState.resumed:
        final shouldReinitialize = _wasBackgrounded ||
            _status == _ScannerStatus.permissionDenied ||
            _status == _ScannerStatus.permissionBlocked;
        _wasBackgrounded = false;
        if (shouldReinitialize) {
          unawaited(_initialize());
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  // =========================================================================
  // Model & Camera setup / teardown
  // =========================================================================

  Future<void> _ensureWorkerInitialized() async {
    if (_worker != null) return;
    final ssdData = await rootBundle.load(_ssdModelAsset);
    final ssdBytes = ssdData.buffer.asUint8List(
      ssdData.offsetInBytes,
      ssdData.lengthInBytes,
    );

    Uint8List? wpodBytes;
    try {
      final wpodData = await rootBundle.load(_wpodModelAsset);
      wpodBytes = wpodData.buffer.asUint8List(
        wpodData.offsetInBytes,
        wpodData.lengthInBytes,
      );
    } catch (_) {
      wpodBytes = null;
    }

    final session = await PlateWorkerSession.start(
      ssdModelBytes: ssdBytes,
      wpodModelBytes: wpodBytes,
    );
    if (!mounted) {
      session.dispose();
      return;
    }
    _worker = session;
    final d = session.diagnostics;
    _logPerf(
      'detector_ready',
      detectMs: d.initMs,
      detail:
          'ssd=${d.ssdWidth}x${d.ssdHeight}(${d.delegateName}) '
          'wpod=${d.wpodWidth}x${d.wpodHeight}(${d.wpodDelegateName}) '
          'loaded=${d.wpodLoaded}',
    );
  }

  bool _isCurrentSession(int session) => mounted && session == _sessionId;

  void _setHud(
    String message, {
    bool isRetrying = false,
    bool isActiveWork = false,
    String? uncertainCandidate,
  }) {
    if (!mounted) return;
    _hudStatus.value = _HudStatus(
      message: message,
      isRetrying: isRetrying,
      isActiveWork: isActiveWork,
      uncertainCandidate: uncertainCandidate ?? _bestUncertainCandidate,
    );
  }

  void _setStatus(_ScannerStatus status, {String? message}) {
    if (!mounted) return;
    setState(() {
      _status = status;
      _errorMessage = message;
    });
    if (status == _ScannerStatus.scanning) {
      _scanLineController.repeat(reverse: true);
      _setHud('Scanning for Number Plate...');
    } else {
      _scanLineController.stop();
      if (status == _ScannerStatus.initializing) {
        _setHud('Initializing Camera...', isActiveWork: true);
      }
    }
  }

  void _onCameraControllerUpdate() {
    final controller = _controller;
    if (controller == null || !mounted) return;
    if (controller.value.hasError && !_isRecoveringCamera) {
      final err = controller.value.errorDescription ?? 'Unknown camera error';
      _logPerf('camera_stream_error', error: err);
      _isRecoveringCamera = true;
      unawaited(_recoverCameraStream());
    }
  }

  Future<void> _recoverCameraStream() async {
    try {
      if (!mounted) return;
      _setHud('Recognition Failed - Retrying...', isRetrying: true);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      await _initialize();
    } finally {
      _isRecoveringCamera = false;
    }
  }

  Future<void> _initialize() async {
    final int session = ++_sessionId;
    await _releaseCamera();
    if (!_isCurrentSession(session)) return;

    _torchOn = false;
    _setStatus(_ScannerStatus.initializing);
    _setHud('Initializing Camera...', isActiveWork: true);

    try {
      await (_workerInitFuture ??= _ensureWorkerInitialized());
    } catch (e) {
      _logPerf('detector_init_error', error: e.toString());
      if (!_isCurrentSession(session)) return;
      _setStatus(
        _ScannerStatus.error,
        message: 'Plate detection model failed to load: $e',
      );
      return;
    }
    if (!_isCurrentSession(session)) return;

    final PermissionStatus permission;
    try {
      permission =
          await Permission.camera.request().timeout(_permissionTimeout);
    } catch (e) {
      _logPerf('permission_error', error: e.toString());
      if (!_isCurrentSession(session)) return;
      _setStatus(
        _ScannerStatus.error,
        message: 'Unable to check camera permission. Please try again.',
      );
      return;
    }
    if (!_isCurrentSession(session)) return;

    if (!permission.isGranted) {
      _setStatus(
        permission.isPermanentlyDenied || permission.isRestricted
            ? _ScannerStatus.permissionBlocked
            : _ScannerStatus.permissionDenied,
      );
      return;
    }

    CameraController? controller;
    try {
      final cameras = await availableCameras().timeout(_cameraListTimeout);
      if (!_isCurrentSession(session)) return;

      final backCameras = cameras
          .where((c) => c.lensDirection == CameraLensDirection.back)
          .toList();
      if (backCameras.isEmpty) {
        _setStatus(
          _ScannerStatus.error,
          message: 'No back camera was found on this device.',
        );
        return;
      }
      final camera = backCameras.first;

      controller = await _createAndInitController(camera, session);
      if (controller == null || !_isCurrentSession(session)) {
        await _safeDispose(controller);
        return;
      }

      _camera = camera;
      _controller = controller;
      controller.addListener(_onCameraControllerUpdate);
      controller = null;

      if (_resumeInPausedState) {
        _resumeInPausedState = false;
        _setStatus(_ScannerStatus.paused);
      } else {
        await _startScanning();
      }
    } on CameraException catch (e) {
      await _safeDispose(controller);
      if (!_isCurrentSession(session)) return;
      _logPerf('camera_init_error', error: '${e.code}: ${e.description}');
      if (e.code.startsWith('CameraAccessDenied')) {
        _setStatus(
          e.code == 'CameraAccessDeniedWithoutPrompt'
              ? _ScannerStatus.permissionBlocked
              : _ScannerStatus.permissionDenied,
        );
      } else if (e.code == 'CameraAccessRestricted') {
        _setStatus(_ScannerStatus.permissionBlocked);
      } else {
        _setStatus(
          _ScannerStatus.error,
          message: 'Camera could not be started'
              '${e.description != null ? ': ${e.description}' : '.'}',
        );
      }
    } catch (e) {
      await _safeDispose(controller);
      if (!_isCurrentSession(session)) return;
      _logPerf('camera_init_exception', error: e.toString());
      _setStatus(
        _ScannerStatus.error,
        message: 'Camera could not be started. Please try again.',
      );
    }
  }

  Future<CameraController?> _createAndInitController(
    CameraDescription camera,
    int session,
  ) async {
    final formatGroup = Platform.isAndroid
        ? ImageFormatGroup.yuv420
        : ImageFormatGroup.bgra8888;

    for (final preset in [ResolutionPreset.high, ResolutionPreset.medium]) {
      final candidate = CameraController(
        camera,
        preset,
        enableAudio: false,
        imageFormatGroup: formatGroup,
      );
      try {
        await candidate.initialize().timeout(_cameraInitTimeout);
        if (!_isCurrentSession(session)) {
          await _safeDispose(candidate);
          return null;
        }
        try {
          await candidate.setFocusMode(FocusMode.auto);
        } catch (_) {}
        return candidate;
      } on CameraException catch (e) {
        await _safeDispose(candidate);
        if (preset == ResolutionPreset.medium ||
            e.code.startsWith('CameraAccess')) {
          rethrow;
        }
      } catch (_) {
        await _safeDispose(candidate);
        if (preset == ResolutionPreset.medium) rethrow;
      }
    }
    return null;
  }

  Future<void> _safeDispose(CameraController? controller) async {
    if (controller == null) return;
    try {
      controller.removeListener(_onCameraControllerUpdate);
      await controller.dispose();
    } catch (e) {
      debugPrint('NumberPlateScanner: camera dispose failed: $e');
    }
  }

  Future<void> _releaseCamera() async {
    final controller = _controller;
    _controller = null;
    _camera = null;
    _isProcessingFrame = false;
    _processingStartedAt = null;
    if (controller == null) return;
    controller.removeListener(_onCameraControllerUpdate);
    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } catch (e) {
      debugPrint('NumberPlateScanner: stopImageStream failed: $e');
    }
    await _safeDispose(controller);
  }

  Future<void> _recreateTextRecognizer() async {
    final old = _textRecognizer;
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      await old.close();
    } catch (_) {}
  }

  // =========================================================================
  // Scanning control
  // =========================================================================

  Future<void> _startScanning() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    _scanGeneration++;
    _resetDetectionState();
    _isProcessingFrame = false;
    _processingStartedAt = null;
    _consecutiveFailures = 0;
    _didResetRecognizerInBurst = false;
    _lastProcessedAt = DateTime.fromMillisecondsSinceEpoch(0);
    _setStatus(_ScannerStatus.scanning);

    try {
      if (!controller.value.isStreamingImages) {
        await controller
            .startImageStream(_onCameraFrame)
            .timeout(_streamStartTimeout);
      }
    } on CameraException catch (e) {
      _logPerf('stream_start_error', error: '${e.code}: ${e.description}');
      _setStatus(
        _ScannerStatus.error,
        message: 'Could not start scanning'
            '${e.description != null ? ': ${e.description}' : '.'}',
      );
    } catch (e) {
      _logPerf('stream_start_exception', error: e.toString());
      _setStatus(
        _ScannerStatus.error,
        message: 'Could not start scanning. Please try again.',
      );
    }
  }

  Future<void> _stopImageStream() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } catch (e) {
      debugPrint('NumberPlateScanner: stopImageStream failed: $e');
    }
  }

  Future<void> _restartScanningImmediately() async {
    _detectedPlate = null;
    _resetDetectionState();
    _isDialogShowing = false;
    _isApiRequestInFlight = false;
    _lastApiVehicleNumber = null;
    _lastApiRequestedAt = null;
    _isProcessingFrame = false;
    _processingStartedAt = null;
    _consecutiveFailures = 0;
    _didResetRecognizerInBurst = false;
    _lastProcessedAt = DateTime.fromMillisecondsSinceEpoch(0);

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      await _initialize();
    } else {
      await _startScanning();
    }
  }

  void _resetDetectionState() {
    _observations.clear();
    _uncertainHits.clear();
    _bestUncertainCandidate = null;
    _detectedWithoutConfirmCount = 0;
    _firstDetectedWithoutConfirmAt = null;
    _lastFrameSampleHash = null;
    _skippedSameHashCount = 0;
    _consecutiveWpodMisses = 0;
  }

  // =========================================================================
  // Frame pipeline
  // =========================================================================

  void _onCameraFrame(CameraImage image) {
    if (_status != _ScannerStatus.scanning ||
        _isDialogShowing ||
        _isApiRequestInFlight ||
        _worker == null) {
      return;
    }

    final now = DateTime.now();

    if (_isProcessingFrame) {
      final startedAt = _processingStartedAt;
      if (startedAt != null &&
          now.difference(startedAt) > _processingWatchdogTimeout) {
        _logPerf('watchdog_reset', error: 'Previous frame exceeded 4s lock');
        _isProcessingFrame = false;
        _processingStartedAt = null;
        _scanGeneration++;
      } else {
        return;
      }
    }

    if (now.difference(_lastProcessedAt) < _frameInterval) return;

    final req = _buildWorkerRequest(image);
    if (req == null) return;

    final int sampleHash = _computeQuickHash(req.yOrBgraBytes);
    if (_lastFrameSampleHash == sampleHash && _skippedSameHashCount < 1) {
      _skippedSameHashCount++;
      return;
    }
    _lastFrameSampleHash = sampleHash;
    _skippedSameHashCount = 0;

    _isProcessingFrame = true;
    _processingStartedAt = now;
    _lastProcessedAt = now;
    final int generation = _scanGeneration;
    final int session = _sessionId;

    unawaited(_processFrame(req, now, session, generation));
  }

  int _computeQuickHash(Uint8List bytes) {
    final len = bytes.length;
    if (len == 0) return 0;
    final step = math.max(1, len ~/ 16);
    int h = 17;
    for (int i = 0; i < len; i += step) {
      h = 31 * h + bytes[i];
    }
    return h;
  }

  WorkerFrameRequest? _buildWorkerRequest(CameraImage image) {
    final camera = _camera;
    final controller = _controller;
    if (camera == null || controller == null || image.planes.isEmpty) {
      return null;
    }

    final int rotationDegrees;
    if (Platform.isIOS) {
      rotationDegrees = ((camera.sensorOrientation % 360) + 360) % 360;
    } else if (Platform.isAndroid) {
      final deviceDegrees =
          _deviceOrientationDegrees[controller.value.deviceOrientation];
      if (deviceDegrees == null) return null;
      rotationDegrees = (camera.sensorOrientation - deviceDegrees + 360) % 360;
    } else {
      return null;
    }

    final bool isBgra = !Platform.isAndroid;
    final yPlane = image.planes[0];
    final uPlane = !isBgra && image.planes.length >= 3 ? image.planes[1] : null;
    final vPlane = !isBgra && image.planes.length >= 3 ? image.planes[2] : null;

    final int dispW = (rotationDegrees == 90 || rotationDegrees == 270)
        ? image.height
        : image.width;
    final int dispH = (rotationDegrees == 90 || rotationDegrees == 270)
        ? image.width
        : image.height;
    final normRoi = _computeNormalizedScanRoi(dispW, dispH);

    return WorkerFrameRequest(
      frameId: ++_frameSeq,
      yOrBgraBytes: Uint8List.fromList(yPlane.bytes),
      uBytes: uPlane != null ? Uint8List.fromList(uPlane.bytes) : null,
      vBytes: vPlane != null ? Uint8List.fromList(vPlane.bytes) : null,
      srcWidth: image.width,
      srcHeight: image.height,
      yRowStride: yPlane.bytesPerRow,
      yPixelStride: yPlane.bytesPerPixel ?? 1,
      uRowStride: uPlane?.bytesPerRow ?? 0,
      vRowStride: vPlane?.bytesPerRow ?? 0,
      uPixelStride: uPlane?.bytesPerPixel ?? 1,
      vPixelStride: vPlane?.bytesPerPixel ?? 1,
      isBgra: isBgra,
      rotationDegrees: rotationDegrees,
      roiLeft: normRoi.left,
      roiTop: normRoi.top,
      roiRight: normRoi.right,
      roiBottom: normRoi.bottom,
      allowSsdFallback: _consecutiveWpodMisses >= 2,
    );
  }

  ({double left, double top, double right, double bottom})
      _computeNormalizedScanRoi(int dispW, int dispH) {
    final viewport = _viewportSize;
    if (viewport == null ||
        viewport.width <= 0 ||
        viewport.height <= 0 ||
        dispW <= 0 ||
        dispH <= 0) {
      return (left: 0.04, top: 0.18, right: 0.96, bottom: 0.68);
    }

    final double screenW = viewport.width;
    final double screenH = viewport.height;
    final double scale = math.max(screenW / dispW, screenH / dispH);

    final double frameWidth = screenW * 0.90;
    final double frameHeight = frameWidth * 0.44;
    final double padW = frameWidth * 0.14;
    final double padH = frameHeight * 0.36;
    final double centerX = screenW / 2;
    final double centerY = screenH * 0.42;

    final double sLeft = centerX - frameWidth / 2 - padW;
    final double sRight = centerX + frameWidth / 2 + padW;
    final double sTop = centerY - frameHeight / 2 - padH;
    final double sBottom = centerY + frameHeight / 2 + padH;

    final double dx0 = ((sLeft - screenW / 2) / scale + dispW / 2) / dispW;
    final double dx1 = ((sRight - screenW / 2) / scale + dispW / 2) / dispW;
    final double dy0 = ((sTop - screenH / 2) / scale + dispH / 2) / dispH;
    final double dy1 = ((sBottom - screenH / 2) / scale + dispH / 2) / dispH;

    return (
      left: dx0.clamp(0.0, 0.9),
      top: dy0.clamp(0.0, 0.9),
      right: dx1.clamp(0.1, 1.0),
      bottom: dy1.clamp(0.1, 1.0),
    );
  }

  Future<void> _processFrame(
    WorkerFrameRequest req,
    DateTime frameReceivedAt,
    int session,
    int generation,
  ) async {
    final totalSw = Stopwatch()..start();
    int framePrepMs = 0;
    int detectMs = 0;
    int cropPrepMs = 0;
    int ocrMs = 0;
    double detectConf = 0.0;

    try {
      final worker = _worker;
      if (worker == null) return;

      final WorkerFrameResult det =
          await worker.processFrame(req).timeout(_workerTimeout);
      framePrepMs = det.framePrepMs;
      detectMs = det.detectMs;
      cropPrepMs = det.cropPreprocessMs;
      detectConf = det.detectConfidence;

      if (det.error != null) {
        throw StateError(det.error!);
      }

      if (!_isScanActive(session, generation)) return;

      if (!det.detected || det.primaryNv21 == null) {
        _consecutiveFailures = 0;
        _consecutiveWpodMisses++;
        if (_hudStatus.value.message != 'Scanning for Number Plate...') {
          _setHud('Scanning for Number Plate...');
        }
        return;
      }

      // Plate detected by TFLite detector! Run OCR ONLY on the corrected crop.
      _consecutiveWpodMisses = 0;
      _setHud('Plate Detected...', isActiveWork: true);
      final ocrSw = Stopwatch()..start();

      final ({
        String? validPlate,
        String? uncertain,
        double ocrConf,
        int valMs,
        bool isExactStrict,
      }) ocrResult = await _runPlateCropOcr(det, session, generation);
      ocrMs = ocrSw.elapsedMilliseconds;

      if (!_isScanActive(session, generation)) return;

      _consecutiveFailures = 0;
      _didResetRecognizerInBurst = false;

      if (ocrResult.validPlate != null) {
        _setHud('Reading Number...', isActiveWork: true);
        final double combinedConf =
            (0.35 * detectConf + 0.65 * ocrResult.ocrConf).clamp(0.0, 1.0);
        _logPerf(
          'plate_ocr_ok',
          frameTs: frameReceivedAt.millisecondsSinceEpoch,
          framePrepMs: framePrepMs,
          detectMs: detectMs,
          cropPrepMs: cropPrepMs,
          ocrMs: ocrMs,
          valMs: ocrResult.valMs,
          totalMs: totalSw.elapsedMilliseconds,
          detectConf: detectConf,
          ocrConf: ocrResult.ocrConf,
          plate: ocrResult.validPlate,
          detail:
              'src=${det.detectorSource} exact=${ocrResult.isExactStrict} '
              'skew=${det.skewAngleDeg.toStringAsFixed(1)} '
              'twoRow=${det.isTwoRowCandidate}',
        );
        await _recordObservationAndVerify(
          plate: ocrResult.validPlate!,
          confidence: combinedConf,
          detectConf: detectConf,
          ocrConf: ocrResult.ocrConf,
          isExactStrict: ocrResult.isExactStrict,
          session: session,
          generation: generation,
        );
      } else {
        _handleUncertainOrMiss(
          uncertain: ocrResult.uncertain,
          frameReceivedAt: frameReceivedAt,
          framePrepMs: framePrepMs,
          detectMs: detectMs,
          cropPrepMs: cropPrepMs,
          ocrMs: ocrMs,
          valMs: ocrResult.valMs,
          totalMs: totalSw.elapsedMilliseconds,
          detectConf: detectConf,
          ocrConf: ocrResult.ocrConf,
        );
      }
    } catch (e) {
      if (!_isScanActive(session, generation)) return;
      _consecutiveFailures++;
      _failedFramesTotal++;
      _logPerf(
        'frame_error',
        frameTs: frameReceivedAt.millisecondsSinceEpoch,
        framePrepMs: framePrepMs,
        detectMs: detectMs,
        cropPrepMs: cropPrepMs,
        ocrMs: ocrMs,
        totalMs: totalSw.elapsedMilliseconds,
        error: e.toString(),
      );
      _setHud('Recognition Failed - Retrying...', isRetrying: true);

      if (_consecutiveFailures >= _recreateRecognizerThreshold &&
          !_didResetRecognizerInBurst) {
        _didResetRecognizerInBurst = true;
        await _recreateTextRecognizer();
      } else if (_consecutiveFailures >= _maxConsecutiveFailures) {
        await _stopImageStream();
        if (_isScanActive(session, generation)) {
          _setStatus(
            _ScannerStatus.error,
            message: 'Scanner encountered repeated errors. Please try again.',
          );
        }
      }
    } finally {
      if (generation == _scanGeneration) {
        _isProcessingFrame = false;
        _processingStartedAt = null;
      }
    }
  }

  /// Runs ML Kit OCR on the straightened plate crop, explicitly handling both
  /// single-row and two-row Indian plates, plus adaptive-threshold fallback.
  Future<
      ({
        String? validPlate,
        String? uncertain,
        double ocrConf,
        int valMs,
        bool isExactStrict,
      })> _runPlateCropOcr(
    WorkerFrameResult det,
    int session,
    int generation,
  ) async {
    _setHud('Reading Number...', isActiveWork: true);

    String? bestUncertain;
    double bestOcrConf = 0.0;
    int totalValMs = 0;

    // 1. Primary straightened & selectively enhanced plate crop.
    final primaryInput = _nv21InputImage(
      det.primaryNv21!,
      det.primaryW,
      det.primaryH,
    );
    final RecognizedText primaryText =
        await _textRecognizer.processImage(primaryInput).timeout(_ocrTimeout);
    if (!_isScanActive(session, generation)) {
      return (
        validPlate: null,
        uncertain: null,
        ocrConf: 0.0,
        valMs: 0,
        isExactStrict: false,
      );
    }

    final primaryParsed = _parseRecognizedPlate(primaryText);
    totalValMs += primaryParsed.valMs;
    if (primaryParsed.validPlate != null) {
      return (
        validPlate: primaryParsed.validPlate,
        uncertain: null,
        ocrConf: primaryParsed.ocrConf,
        valMs: totalValMs,
        isExactStrict: primaryParsed.isExactStrict,
      );
    }
    bestUncertain = primaryParsed.uncertain ?? bestUncertain;
    bestOcrConf = math.max(bestOcrConf, primaryParsed.ocrConf);

    // 2. Explicit two-row split OCR when crop aspect ratio suggests 2 rows
    //    (e.g., two-wheelers / commercial stacked plates).
    if (det.isTwoRowCandidate &&
        det.topRowNv21 != null &&
        det.bottomRowNv21 != null) {
      final topText = await _textRecognizer
          .processImage(
            _nv21InputImage(det.topRowNv21!, det.topRowW, det.topRowH),
          )
          .timeout(_ocrTimeout);
      if (!_isScanActive(session, generation)) {
        return (
          validPlate: null,
          uncertain: null,
          ocrConf: 0.0,
          valMs: totalValMs,
          isExactStrict: false,
        );
      }

      final bottomText = await _textRecognizer
          .processImage(
            _nv21InputImage(det.bottomRowNv21!, det.bottomRowW, det.bottomRowH),
          )
          .timeout(_ocrTimeout);
      if (!_isScanActive(session, generation)) {
        return (
          validPlate: null,
          uncertain: null,
          ocrConf: 0.0,
          valMs: totalValMs,
          isExactStrict: false,
        );
      }

      final row1 = _sortLinesLeftToRight(topText);
      final row2 = _sortLinesLeftToRight(bottomText);
      final combinedTwoRow = '${IndianPlateValidator.stripNoise(row1)} '
              '${IndianPlateValidator.stripNoise(row2)}'
          .trim();

      if (combinedTwoRow.isNotEmpty) {
        final twoRowConf =
            (_averageLineConfidence(topText) + _averageLineConfidence(bottomText)) /
                2.0;
        final twoRowMatch = _extractFromCombinedText(combinedTwoRow, twoRowConf);
        totalValMs += twoRowMatch.valMs;
        if (twoRowMatch.validPlate != null) {
          return (
            validPlate: twoRowMatch.validPlate,
            uncertain: null,
            ocrConf: twoRowMatch.ocrConf,
            valMs: totalValMs,
            isExactStrict: twoRowMatch.isExactStrict,
          );
        }
        bestUncertain ??= twoRowMatch.uncertain;
        bestOcrConf = math.max(bestOcrConf, twoRowMatch.ocrConf);
      }
    }

    // 3. Adaptive-threshold fallback for uneven lighting / glare / blur.
    if (det.adaptiveNv21 != null) {
      final adaptiveText = await _textRecognizer
          .processImage(
            _nv21InputImage(det.adaptiveNv21!, det.primaryW, det.primaryH),
          )
          .timeout(_ocrTimeout);
      if (!_isScanActive(session, generation)) {
        return (
          validPlate: null,
          uncertain: null,
          ocrConf: 0.0,
          valMs: totalValMs,
          isExactStrict: false,
        );
      }

      final adaptiveParsed = _parseRecognizedPlate(adaptiveText);
      totalValMs += adaptiveParsed.valMs;
      if (adaptiveParsed.validPlate != null) {
        return (
          validPlate: adaptiveParsed.validPlate,
          uncertain: null,
          ocrConf: adaptiveParsed.ocrConf,
          valMs: totalValMs,
          isExactStrict: adaptiveParsed.isExactStrict,
        );
      }
      bestUncertain ??= adaptiveParsed.uncertain;
      bestOcrConf = math.max(bestOcrConf, adaptiveParsed.ocrConf);
    }

    return (
      validPlate: null,
      uncertain: bestUncertain,
      ocrConf: bestOcrConf,
      valMs: totalValMs,
      isExactStrict: false,
    );
  }

  /// Spatial top-to-bottom + left-to-right assembly across ML Kit lines so
  /// stacked two-row plates are always combined in the right reading order.
  ({
    String? validPlate,
    String? uncertain,
    double ocrConf,
    int valMs,
    bool isExactStrict,
  }) _parseRecognizedPlate(RecognizedText recognizedText) {
    final allLines = <TextLine>[];
    for (final b in recognizedText.blocks) {
      allLines.addAll(b.lines);
    }
    if (allLines.isEmpty) {
      return (
        validPlate: null,
        uncertain: null,
        ocrConf: 0.0,
        valMs: 0,
        isExactStrict: false,
      );
    }

    // Cluster into rows sorted top-to-bottom, then left-to-right.
    allLines.sort(
      (a, b) => a.boundingBox.center.dy.compareTo(b.boundingBox.center.dy),
    );
    final rows = <List<TextLine>>[];
    for (final line in allLines) {
      if (rows.isEmpty) {
        rows.add([line]);
        continue;
      }
      final prevRow = rows.last;
      final avgY = prevRow
              .map((l) => l.boundingBox.center.dy)
              .reduce((a, b) => a + b) /
          prevRow.length;
      final avgH =
          prevRow.map((l) => l.boundingBox.height).reduce((a, b) => a + b) /
              prevRow.length;
      if ((line.boundingBox.center.dy - avgY).abs() <=
          math.max(12.0, avgH * 0.55)) {
        prevRow.add(line);
      } else {
        rows.add([line]);
      }
    }

    final rowStrings = <String>[];
    for (final row in rows) {
      row.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
      final joined = row.map((l) => l.text).join(' ');
      final cleaned = IndianPlateValidator.stripNoise(joined);
      if (cleaned.isNotEmpty) rowStrings.add(cleaned);
    }

    final orderedText = rowStrings.join('\n');
    final conf = _averageLineConfidence(recognizedText);
    return _extractFromCombinedText(orderedText, conf);
  }

  ({
    String? validPlate,
    String? uncertain,
    double ocrConf,
    int valMs,
    bool isExactStrict,
  }) _extractFromCombinedText(String orderedText, double ocrConf) {
    if (orderedText.trim().isEmpty) {
      return (
        validPlate: null,
        uncertain: null,
        ocrConf: 0.0,
        valMs: 0,
        isExactStrict: false,
      );
    }

    final valSw = Stopwatch()..start();
    final List<String> candidates =
        _plateService.extractPlatesFromText(orderedText);
    for (final c in candidates) {
      final strict = IndianPlateValidator.validate(c);
      if (strict != null) {
        return (
          validPlate: strict,
          uncertain: null,
          ocrConf: ocrConf,
          valMs: valSw.elapsedMilliseconds,
          isExactStrict: true,
        );
      }
      final valid = IndianPlateValidator.repairAndValidate(c);
      if (valid != null) {
        return (
          validPlate: valid,
          uncertain: null,
          ocrConf: ocrConf,
          valMs: valSw.elapsedMilliseconds,
          isExactStrict: false,
        );
      }
    }

    final directStrict = IndianPlateValidator.validate(orderedText);
    if (directStrict != null) {
      return (
        validPlate: directStrict,
        uncertain: null,
        ocrConf: ocrConf,
        valMs: valSw.elapsedMilliseconds,
        isExactStrict: true,
      );
    }

    final directRepaired = IndianPlateValidator.repairAndValidate(orderedText);
    if (directRepaired != null) {
      return (
        validPlate: directRepaired,
        uncertain: null,
        ocrConf: ocrConf,
        valMs: valSw.elapsedMilliseconds,
        isExactStrict: false,
      );
    }

    final uncertain =
        IndianPlateValidator.extractBestUncertainCandidate(orderedText);
    return (
      validPlate: null,
      uncertain: uncertain,
      ocrConf: ocrConf,
      valMs: valSw.elapsedMilliseconds,
      isExactStrict: false,
    );
  }

  String _sortLinesLeftToRight(RecognizedText text) {
    final lines = <TextLine>[];
    for (final b in text.blocks) {
      lines.addAll(b.lines);
    }
    lines.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
    return lines.map((l) => l.text).join(' ');
  }

  double _averageLineConfidence(RecognizedText text) {
    double sum = 0;
    int count = 0;
    for (final b in text.blocks) {
      for (final l in b.lines) {
        if (l.confidence != null) {
          sum += l.confidence!.clamp(0.0, 1.0);
          count++;
        }
      }
    }
    return count > 0 ? (sum / count).clamp(0.0, 1.0) : 0.76;
  }

  void _handleUncertainOrMiss({
    required String? uncertain,
    required DateTime frameReceivedAt,
    required int framePrepMs,
    required int detectMs,
    required int cropPrepMs,
    required int ocrMs,
    required int valMs,
    required int totalMs,
    required double detectConf,
    required double ocrConf,
  }) {
    _failedFramesTotal++;
    _detectedWithoutConfirmCount++;
    _firstDetectedWithoutConfirmAt ??= frameReceivedAt;

    if (uncertain != null) {
      _uncertainHits[uncertain] = (_uncertainHits[uncertain] ?? 0) + 1;
      String? topCandidate;
      int topCount = 0;
      for (final e in _uncertainHits.entries) {
        if (e.value > topCount) {
          topCount = e.value;
          topCandidate = e.key;
        }
      }
      _bestUncertainCandidate = topCandidate;
    }

    final elapsedSinceFirst = frameReceivedAt
        .difference(_firstDetectedWithoutConfirmAt ?? frameReceivedAt);

    _logPerf(
      'plate_uncertain',
      frameTs: frameReceivedAt.millisecondsSinceEpoch,
      framePrepMs: framePrepMs,
      detectMs: detectMs,
      cropPrepMs: cropPrepMs,
      ocrMs: ocrMs,
      valMs: valMs,
      totalMs: totalMs,
      detectConf: detectConf,
      ocrConf: ocrConf,
      plate: uncertain,
    );

    if (elapsedSinceFirst >= const Duration(milliseconds: 1600) &&
        _bestUncertainCandidate != null) {
      _setHud(
        'Uncertain read — tap to verify or keep steady',
        uncertainCandidate: _bestUncertainCandidate,
      );
    } else if (_detectedWithoutConfirmCount >= 7) {
      _setHud(
        'Plate unclear — hold steady or improve lighting',
        isRetrying: true,
        uncertainCandidate: _bestUncertainCandidate,
      );
    } else {
      _setHud(
        'Reading Number...',
        isActiveWork: true,
        uncertainCandidate: _bestUncertainCandidate,
      );
    }
  }

  bool _isScanActive(int session, int generation) =>
      mounted &&
      session == _sessionId &&
      generation == _scanGeneration &&
      _status == _ScannerStatus.scanning &&
      !_isDialogShowing;

  InputImage _nv21InputImage(Uint8List nv21, int width, int height) {
    return InputImage.fromBytes(
      bytes: nv21,
      metadata: InputImageMetadata(
        size: Size(width.toDouble(), height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: width,
      ),
    );
  }

  // =========================================================================
  // Multi-frame verification & Result / Manual Verify dialogs
  // =========================================================================

  Future<void> _recordObservationAndVerify({
    required String plate,
    required double confidence,
    required double detectConf,
    required double ocrConf,
    required bool isExactStrict,
    required int session,
    required int generation,
  }) async {
    final now = DateTime.now();
    _recentResultsCache.removeWhere(
      (_, ts) => now.difference(ts) > _recentCacheTtl,
    );

    final bool isCachedRecent = _recentResultsCache.containsKey(plate);
    final bool instantHighConf = isExactStrict &&
        detectConf >= _instantConfirmDetectConf &&
        ocrConf >= _instantConfirmOcrConf;

    if ((instantHighConf || isCachedRecent) &&
        _isScanActive(session, generation)) {
      _recentResultsCache[plate] = now;
      _logPerf(
        'plate_confirmed',
        frameTs: now.millisecondsSinceEpoch,
        detectConf: detectConf,
        ocrConf: ocrConf,
        plate: plate,
        detail: isCachedRecent ? 'mode=cached_instant' : 'mode=single_frame',
      );
      await _handleConfirmedPlate(plate);
      return;
    }

    _observations.removeWhere(
      (o) => now.difference(o.timestamp) > _confirmWindow,
    );
    _observations.add(
      _FrameObservation(
        plate: plate,
        confidence: confidence,
        timestamp: now,
      ),
    );

    final Map<String, List<_FrameObservation>> grouped = {};
    for (final obs in _observations) {
      grouped.putIfAbsent(obs.plate, () => []).add(obs);
    }

    String? confirmedPlate;
    double confirmedConf = 0.0;

    for (final entry in grouped.entries) {
      final list = entry.value;
      final double avgConf =
          list.fold<double>(0.0, (s, e) => s + e.confidence) / list.length;

      if (list.length >= _fallbackVoteFrames && avgConf >= confirmedConf) {
        confirmedPlate = entry.key;
        confirmedConf = avgConf;
      }
    }

    if (confirmedPlate != null && _isScanActive(session, generation)) {
      _recentResultsCache[confirmedPlate] = now;
      _logPerf(
        'plate_confirmed',
        frameTs: now.millisecondsSinceEpoch,
        detectConf: detectConf,
        ocrConf: confirmedConf,
        plate: confirmedPlate,
        detail: 'mode=multi_frame_vote',
      );
      await _handleConfirmedPlate(confirmedPlate);
    }
  }

  Future<void> _handleConfirmedPlate(String plate) async {
    if (_isDialogShowing ||
        _isApiRequestInFlight ||
        _status != _ScannerStatus.scanning) {
      return;
    }
    if (_lastApiVehicleNumber == plate &&
        _lastApiRequestedAt != null &&
        DateTime.now().difference(_lastApiRequestedAt!) <
            const Duration(seconds: 4)) {
      return;
    }
    _isDialogShowing = true;
    _scanGeneration++;
    _detectedPlate = plate;
    _resetDetectionState();
    _setStatus(_ScannerStatus.paused);

    await _stopImageStream();
    if (!mounted) {
      _isDialogShowing = false;
      return;
    }
    HapticFeedback.mediumImpact();

    _isDialogShowing = false;
    await _navigateToVehicleDetails(plate);
  }

  Future<void> _navigateToVehicleDetails(String plate) async {
    if (_isApiRequestInFlight || !mounted) return;
    _isApiRequestInFlight = true;
    _lastApiVehicleNumber = plate;
    _lastApiRequestedAt = DateTime.now();

    bool? scanAgain;
    try {
      scanAgain = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => VehicleLoadingScreen(
            vehicleNumber: plate,
            apiService: _vehicleApiService,
          ),
        ),
      );
    } finally {
      _isApiRequestInFlight = false;
    }

    if (!mounted) return;
    if (scanAgain == true) {
      await _restartScanningImmediately();
    }
  }

  Future<void> _openManualVerifyDialog(String initialCandidate) async {
    if (_isDialogShowing ||
        _isApiRequestInFlight ||
        _status != _ScannerStatus.scanning) {
      return;
    }
    _isDialogShowing = true;
    _scanGeneration++;
    _setStatus(_ScannerStatus.paused);
    await _stopImageStream();
    if (!mounted) {
      _isDialogShowing = false;
      return;
    }

    final String? confirmed = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) =>
          _ManualVerifyDialog(initialPlate: initialCandidate),
    );

    _isDialogShowing = false;
    if (!mounted) return;
    if (confirmed != null && confirmed.isNotEmpty) {
      _detectedPlate = confirmed;
      _resetDetectionState();
      await _navigateToVehicleDetails(confirmed);
    } else {
      await _restartScanningImmediately();
    }
  }

  // =========================================================================
  // Logging
  // =========================================================================

  void _logPerf(
    String event, {
    int? frameTs,
    int? framePrepMs,
    int? detectMs,
    int? cropPrepMs,
    int? ocrMs,
    int? valMs,
    int? totalMs,
    double? detectConf,
    double? ocrConf,
    String? plate,
    String? detail,
    String? error,
  }) {
    final parts = <String>['event=$event'];
    if (frameTs != null) parts.add('frameTs=$frameTs');
    if (framePrepMs != null) parts.add('framePrepMs=$framePrepMs');
    if (detectMs != null) parts.add('detectMs=$detectMs');
    if (cropPrepMs != null && cropPrepMs > 0) parts.add('cropMs=$cropPrepMs');
    if (ocrMs != null && ocrMs > 0) parts.add('ocrMs=$ocrMs');
    if (valMs != null) parts.add('valMs=$valMs');
    if (totalMs != null) parts.add('totalMs=$totalMs');
    if (detectConf != null && detectConf > 0) {
      parts.add('detConf=${detectConf.toStringAsFixed(2)}');
    }
    if (ocrConf != null && ocrConf > 0) {
      parts.add('ocrConf=${ocrConf.toStringAsFixed(2)}');
    }
    parts.add('failedFrames=$_failedFramesTotal');
    if (plate != null) parts.add('plate=$plate');
    if (detail != null) parts.add(detail);
    if (error != null) parts.add('error=$error');

    final msg = 'NumberPlateScanner | ${parts.join(' ')}';
    developer.log(msg, name: 'NumberPlateScanner');
    debugPrint(msg);
  }

  // =========================================================================
  // Flashlight
  // =========================================================================

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final bool next = !_torchOn;
    try {
      await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      if (!mounted) return;
      setState(() => _torchOn = next);
    } catch (e) {
      debugPrint('NumberPlateScanner: torch unavailable: $e');
      if (!mounted) return;
      setState(() {
        _torchSupported = false;
        _torchOn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flashlight is not available on this device.'),
        ),
      );
    }
  }

  bool get _canShowTorch =>
      _torchSupported &&
      _controller != null &&
      (_status == _ScannerStatus.scanning || _status == _ScannerStatus.paused);

  // =========================================================================
  // UI
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Number Plate Scanner'),
        backgroundColor: Colors.black.withAlpha(90),
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          if (_canShowTorch)
            IconButton(
              tooltip: _torchOn ? 'Turn flashlight off' : 'Turn flashlight on',
              icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
              onPressed: _toggleTorch,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _ScannerStatus.initializing:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Initializing Camera...',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          ),
        );
      case _ScannerStatus.permissionDenied:
        return _buildMessageView(
          icon: Icons.no_photography_outlined,
          title: 'Camera permission required',
          message: 'Allow camera access so the app can scan vehicle number '
              'plates automatically.',
          buttonLabel: 'Allow Camera',
          onPressed: () => unawaited(_initialize()),
        );
      case _ScannerStatus.permissionBlocked:
        return _buildMessageView(
          icon: Icons.no_photography_outlined,
          title: 'Camera access is blocked',
          message: 'Camera permission has been denied permanently. Enable it '
              'in your phone\'s app settings to use the scanner.',
          buttonLabel: 'Open Settings',
          onPressed: () => unawaited(openAppSettings()),
        );
      case _ScannerStatus.error:
        return _buildMessageView(
          icon: Icons.error_outline,
          title: 'Something went wrong',
          message: _errorMessage ?? 'The scanner could not be started.',
          buttonLabel: 'Try Again',
          onPressed: () => unawaited(_initialize()),
        );
      case _ScannerStatus.scanning:
      case _ScannerStatus.paused:
        return _buildScannerView();
    }
  }

  Widget _buildMessageView({
    required IconData icon,
    required String title,
    required String message,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: Colors.white70),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onPressed, child: Text(buttonLabel)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Text(
          'Initializing Camera...',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    final bool isScanning = _status == _ScannerStatus.scanning;

    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = constraints.biggest;
        _viewportSize = size;

        final double frameWidth = size.width * 0.9;
        final double frameHeight = frameWidth * 0.44;
        final Rect frameRect = Rect.fromCenter(
          center: Offset(size.width / 2, size.height * 0.42),
          width: frameWidth,
          height: frameHeight,
        );
        final double bottomInset = MediaQuery.of(context).padding.bottom;

        return Stack(
          fit: StackFit.expand,
          children: [
            _buildCameraPreview(controller),
            CustomPaint(
              painter: _ScannerOverlayPainter(
                frameRect: frameRect,
                cornerColor:
                    isScanning ? Colors.lightGreenAccent : Colors.white,
              ),
            ),
            if (isScanning)
              AnimatedBuilder(
                animation: _scanLineController,
                builder: (context, _) {
                  final double lineTop = frameRect.top +
                      8 +
                      (frameRect.height - 19) * _scanLineController.value;
                  return Positioned(
                    left: frameRect.left + 12,
                    width: frameRect.width - 24,
                    top: lineTop,
                    height: 3,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightGreenAccent.withAlpha(0),
                            Colors.lightGreenAccent,
                            Colors.lightGreenAccent.withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            Positioned(
              left: 24,
              right: 24,
              top: frameRect.bottom + 16,
              child: const Text(
                'Position the vehicle number plate inside the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: bottomInset + 24,
              child: isScanning ? _buildScanningChip() : _buildPausedCard(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCameraPreview(CameraController controller) {
    final previewSize = controller.value.previewSize;
    if (previewSize == null) return CameraPreview(controller);

    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double width = isPortrait ? previewSize.height : previewSize.width;
    final double height = isPortrait ? previewSize.width : previewSize.height;

    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: width,
            height: height,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildScanningChip() {
    return ValueListenableBuilder<_HudStatus>(
      valueListenable: _hudStatus,
      builder: (context, hud, _) {
        final Color dotColor = hud.isRetrying
            ? Colors.orangeAccent
            : (hud.isActiveWork ? Colors.cyanAccent : Colors.lightGreenAccent);
        final uncertain = hud.uncertainCandidate;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (uncertain != null) ...[
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.black,
                ),
                onPressed: () =>
                    unawaited(_openManualVerifyDialog(uncertain)),
                icon: const Icon(Icons.edit_note),
                label: Text('Verify: $uncertain'),
              ),
              const SizedBox(height: 8),
            ],
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(165),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: dotColor.withAlpha(110)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hud.isRetrying
                          ? Icons.refresh
                          : (hud.isActiveWork
                              ? Icons.document_scanner_outlined
                              : Icons.center_focus_strong),
                      size: 16,
                      color: dotColor,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        hud.message,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPausedCard() {
    final plate = _detectedPlate;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (plate != null) ...[
              const Text('Last detected vehicle number'),
              const SizedBox(height: 4),
              Text(
                plate,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                if (plate != null)
                  OutlinedButton.icon(
                    onPressed: () => unawaited(_navigateToVehicleDetails(plate)),
                    icon: const Icon(Icons.verified_user_outlined),
                    label: const Text('Vehicle Details'),
                  ),
                FilledButton.icon(
                  onPressed: () => unawaited(_restartScanningImmediately()),
                  icon: const Icon(Icons.document_scanner_outlined),
                  label: const Text('Scan Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualVerifyDialog extends StatefulWidget {
  const _ManualVerifyDialog({required this.initialPlate});

  final String initialPlate;

  @override
  State<_ManualVerifyDialog> createState() => _ManualVerifyDialogState();
}

class _ManualVerifyDialogState extends State<_ManualVerifyDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPlate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalized = IndianPlateValidator.normalize(_controller.text);
    final isValid = IndianPlateValidator.validate(normalized) != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Verify Number Plate'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OCR read an uncertain plate. Confirm or correct the characters:',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              helperText: isValid
                  ? 'Valid Indian registration format'
                  : 'Check state/RTO/digits before confirming',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Scan Again'),
        ),
        FilledButton(
          onPressed: normalized.isEmpty
              ? null
              : () => Navigator.of(context).pop(normalized),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

/// Dims everything outside the scan frame and draws accent corner brackets.
class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({required this.frameRect, required this.cornerColor});

  final Rect frameRect;
  final Color cornerColor;

  static const double _radius = 16;
  static const double _cornerLength = 32;

  @override
  void paint(Canvas canvas, Size size) {
    final frame =
        RRect.fromRectAndRadius(frameRect, const Radius.circular(_radius));

    final dimmed = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRRect(frame),
    );
    canvas.drawPath(dimmed, Paint()..color = Colors.black.withAlpha(140));

    canvas.drawRRect(
      frame,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withAlpha(110),
    );

    final cornerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = cornerColor;

    final l = frameRect.left;
    final t = frameRect.top;
    final r = frameRect.right;
    final b = frameRect.bottom;
    const rad = Radius.circular(_radius);

    final corners = Path()
      ..moveTo(l, t + _cornerLength)
      ..lineTo(l, t + _radius)
      ..arcToPoint(Offset(l + _radius, t), radius: rad)
      ..lineTo(l + _cornerLength, t)
      ..moveTo(r - _cornerLength, t)
      ..lineTo(r - _radius, t)
      ..arcToPoint(Offset(r, t + _radius), radius: rad)
      ..lineTo(r, t + _cornerLength)
      ..moveTo(r, b - _cornerLength)
      ..lineTo(r, b - _radius)
      ..arcToPoint(Offset(r - _radius, b), radius: rad)
      ..lineTo(r - _cornerLength, b)
      ..moveTo(l + _cornerLength, b)
      ..lineTo(l + _radius, b)
      ..arcToPoint(Offset(l, b - _radius), radius: rad)
      ..lineTo(l, b - _cornerLength);
    canvas.drawPath(corners, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) =>
      oldDelegate.frameRect != frameRect ||
      oldDelegate.cornerColor != cornerColor;
}
