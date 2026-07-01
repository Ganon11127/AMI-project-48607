import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'text_recognition_service.dart';

class TextRecognitionServiceImpl implements TextRecognitionService {
  final TextRecognizer _recognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<String> recognizeText(XFile image) async {
    final inputImage = InputImage.fromFile(File(image.path));
    final recognized = await _recognizer.processImage(inputImage);
    // Find the text block with the largest font size
    String bestText = recognized.text;
    double maxFontSize = 0;
    for (final block in recognized.blocks) {
      for (final line in block.lines) {
        if (line.cornerPoints.isNotEmpty && line.elements.isNotEmpty) {
          final fontSize = line.boundingBox.height;
          if (fontSize > maxFontSize) {
            maxFontSize = fontSize;
            bestText = line.text;
          }
        }
      }
    }
    return bestText.trim();
  }

  @override
  void dispose() {
    _recognizer.close();
  }
}