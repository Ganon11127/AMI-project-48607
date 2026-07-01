import 'package:camera/camera.dart';

abstract class CameraHandler {
  Future<void> initialize();
  Future<XFile> takePicture();
  void dispose();
  bool get isInitialized;
  CameraController? get controller;
}