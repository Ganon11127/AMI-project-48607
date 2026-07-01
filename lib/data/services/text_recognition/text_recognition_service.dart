import 'package:camera/camera.dart';

abstract class TextRecognitionService {
  Future<String> recognizeText(XFile image);
  void dispose();
}