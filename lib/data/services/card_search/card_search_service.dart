import '../../models/card_model.dart';

abstract class CardSearchService {
  Future<CardModel?> searchCard(String query);
}