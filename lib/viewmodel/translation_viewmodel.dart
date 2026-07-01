import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../data/models/card_model.dart';
import '../data/services/camera/camera_handler.dart';
import '../data/services/text_recognition/text_recognition_service.dart';
import '../data/services/card_search/card_search_service.dart';

class TranslationViewModel extends ChangeNotifier {
  final CameraHandler _cameraHandler;
  final TextRecognitionService _textRecognitionService;
  final CardSearchService _cardSearchService;

  bool _isCameraReady = false;
  String _recognizedText = '';
  CardModel? _matchedCard;
  bool _isSearching = false;
  String? _searchErrorCode;
  Map<String, String>? _errorParams;

  TranslationViewModel({
    required CameraHandler cameraHandler,
    required TextRecognitionService textRecognitionService,
    required CardSearchService cardSearchService,
  }) : _cameraHandler = cameraHandler,
       _textRecognitionService = textRecognitionService,
       _cardSearchService = cardSearchService;

  // ===== Getters =====
  bool get isCameraReady => _isCameraReady;
  String get recognizedText => _recognizedText;
  CardModel? get matchedCard => _matchedCard;
  bool get isSearching => _isSearching;
  String? get searchErrorCode => _searchErrorCode;
  Map<String, String>? get errorParams => _errorParams;
  CameraController? get cameraController => _cameraHandler.controller; // added

  // ===== Camera Management =====
  Future<void> initializeCamera() async {
    try {
      await _cameraHandler.initialize();
      _isCameraReady = true;
      notifyListeners();
    } catch (e) {
      _isCameraReady = false;
      _searchErrorCode = 'errorOccurred';
      _errorParams = {'error': e.toString()};
      notifyListeners();
    }
  }

  // ===== Image Processing and Card Search =====
  Future<void> processImageAndSearch() async {
    _isSearching = true;
    _searchErrorCode = null;
    _errorParams = null;
    _matchedCard = null;
    notifyListeners();

    try {
      if (!_isCameraReady) {
        _searchErrorCode = 'errorOccurred';
        _errorParams = {'error': 'Camera not ready'};
        return;
      }

      final image = await _cameraHandler.takePicture();
      _recognizedText = await _textRecognitionService.recognizeText(image);
      notifyListeners();

      if (_recognizedText.isNotEmpty) {
        final card = await _cardSearchService.searchCard(_recognizedText);
        if (card != null) {
          _matchedCard = card;
        } else {
          _searchErrorCode = 'noCardFound';
          _errorParams = {'text': _recognizedText};
        }
      } else {
        _searchErrorCode = 'noCardFound';
        _errorParams = {'text': 'No text recognized'};
      }
    } catch (e) {
      _searchErrorCode = 'errorOccurred';
      _errorParams = {'error': e.toString()};
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // ===== UI Helpers (Pendulum / Monster Effect Extraction) =====
  String? get pendulumEffectText {
    final card = _matchedCard;
    if (card == null) return null;
    final desc = card.desc;
    if (desc.contains('[ Pendulum Effect ]')) {
      final start = desc.indexOf('[ Pendulum Effect ]');
      final end = desc.indexOf('[ Monster Effect ]');
      if (end == -1) return desc.substring(start).trim();
      return desc.substring(start, end).trim();
    }
    return null;
  }

  String? get cardEffectText {
    final card = _matchedCard;
    if (card == null) return null;
    final desc = card.desc;
    if (desc.contains('[ Monster Effect ]')) {
      final start = desc.indexOf('[ Monster Effect ]');
      return desc.substring(start).trim();
    }
    return desc;
  }

  // ===== Cleanup =====
  @override
  void dispose() {
    _cameraHandler.dispose();
    _textRecognitionService.dispose();
    super.dispose();
  }
}