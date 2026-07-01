import 'package:camera/camera.dart';

import 'camera_handler.dart';

class CameraHandlerImpl implements CameraHandler {
  CameraController? _controller;
  bool _initialized = false;

  @override
  bool get isInitialized => _initialized;

  @override
  CameraController? get controller => _controller;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No camera available');
    }
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    await _controller!.initialize();
    _initialized = true;
  }

  @override
  Future<XFile> takePicture() async {
    if (!_initialized || _controller == null) {
      throw Exception('Camera not initialized');
    }
    return await _controller!.takePicture();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _initialized = false;
  }
}