import '../models/card_model.dart';

/// abstract class for the Card Repository.
abstract class CardRepository {
  /// searches for a card by its name using fuzzy logic.
  /// [searchQuery]: is the raw text to search for.
  /// [languageCode]: is the language code ('', 'fr', 'de', etc.) for the data to search in.
  /// Returns [CardModel]: if a match is found, otherwise returns null.
  Future< CardModel? > searchCard( String searchQuery, String languageCode );

  
  /// searches for a card by by id
  /// [id]: card id because if a card in portuguese as the id '999' then each language will share that id
  /// [languageCode]: is the language code ('', 'fr', 'de', etc.) for the data to search in.
  /// Returns [CardModel]: if a match is found, otherwise returns null.
  Future<CardModel?> searchCardById( int id, String languageCode );

  /// get all cards for a language
  Future<List<CardModel>> getAllCards(String languageCode);
}