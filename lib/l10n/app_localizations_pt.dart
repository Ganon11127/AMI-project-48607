// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Yu‑Gi‑Oh App';

  @override
  String get homeTitle => 'Início';

  @override
  String get overview => 'Visão Geral dos Preços dos Decks';

  @override
  String get favouritedDecks => 'Decks Favoritos';

  @override
  String get bookmarkedCards => 'Cartas Favoritas';

  @override
  String get wishlistedCards => 'Cartas na Lista de Desejos';

  @override
  String get wishlistedDecks => 'Decks na Lista de Desejos';

  @override
  String get settingsTitle => 'Opções';

  @override
  String get bottomNavCatalog => 'Catálogo';

  @override
  String get bottomNavDeck => 'Deck';

  @override
  String get bottomNavHome => 'Início';

  @override
  String get bottomNavTranslation => 'Tradução';

  @override
  String get bottomNavBattle => 'Batalha';

  @override
  String get translationTitle => 'Traduzir';

  @override
  String get translationHint => 'Aponte a câmara para o texto';

  @override
  String get findCardButton => 'Encontrar Carta';

  @override
  String get languageOptions => 'Opções de Idioma';

  @override
  String get langEnglish => 'Inglês';

  @override
  String get langPortuguese => 'Português';

  @override
  String get langFrench => 'Francês';

  @override
  String get langGerman => 'Alemão';

  @override
  String get langItalian => 'Italiano';

  @override
  String get languagePrefix => 'Idioma: ';

  @override
  String get appLanguage => 'Idioma da App';

  @override
  String get cardTranslation => 'Tradução de Cartas';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get marketOptions => 'Opções de Mercado';

  @override
  String get markets => 'Mercados';

  @override
  String get currency => 'Moeda';

  @override
  String get eur => 'Euro';

  @override
  String get usd => 'Dólar';

  @override
  String noCardFound(String text) {
    return 'Nenhuma carta encontrada para: $text';
  }

  @override
  String errorOccurred(String text) {
    return 'Ocorreu um erro: $text';
  }

  @override
  String cardArchetype(String text) {
    return 'Arquétipo: $text';
  }

  @override
  String cardAttribute(String text) {
    return 'Atributo: $text';
  }

  @override
  String cardType(String text) {
    return 'Tipo: $text';
  }

  @override
  String get pendulumEffectLabel => 'Efeito de Pêndulo';

  @override
  String get monsterEffectLabel => 'Efeito de Monstro';

  @override
  String get searching => 'A pesquisar…';

  @override
  String get marketCardmarket => 'Cardmarket';

  @override
  String get marketTcgplayer => 'TCGPlayer';

  @override
  String get marketCoolstuffinc => 'CoolStuffInc';

  @override
  String get marketEbay => 'Ebay';

  @override
  String get marketAmazon => 'Amazon';

  @override
  String get battlePlayer => 'Jogador';

  @override
  String get battleHelpTitle => 'Controlos de Batalha';

  @override
  String get battleHelpReset => 'Repor LP para 8000';

  @override
  String get battleHelpRotate => 'Rodar ecrã 90°';

  @override
  String get battleHelpSettings => 'Abrir Definições';

  @override
  String get battleHelpToggleNav => 'Mostrar/ocultar navegação inferior';

  @override
  String get battleHelpTranslate => 'Ir para Tradução';

  @override
  String get battleHelpClose => 'Fechar';

  @override
  String get battleCalculatorTitle => 'Definir Pontos de Vida';

  @override
  String get battleCalculatorHint => 'Introduza o valor de LP';

  @override
  String get battleCalculatorSet => 'Definir';

  @override
  String get battleHelpSensor =>
      'Agite o telemóvel para lançar dados. Imite o movimento de uma moeda para o lançamento da moeda.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resetConfirmTitle => 'Repor Pontos de Vida';

  @override
  String get resetConfirmContent =>
      'Tem a certeza que pretende repor os LP de ambos os jogadores para 8000?';

  @override
  String get resetConfirmReset => 'Repor';

  @override
  String get resultTitle => 'Resultado';

  @override
  String get dicePrefix => 'Dados';

  @override
  String get coinHeads => 'Cara';

  @override
  String get coinTails => 'Coroa';

  @override
  String get deleteDeckTitle => 'Eliminar Deck';

  @override
  String get deleteDeckContent =>
      'Tem a certeza que pretende eliminar este deck? Esta ação não pode ser desfeita.';

  @override
  String get delete => 'Eliminar';

  @override
  String get deckListTitle => 'Decks';

  @override
  String get searchDecks => 'Pesquisar decks…';

  @override
  String get noDecksFound => 'Nenhum deck encontrado';

  @override
  String get mainDeck => 'Deck Principal';

  @override
  String get extraDeck => 'Deck Extra';

  @override
  String get empty => 'Vazio';

  @override
  String get unknownCard => 'Carta Desconhecida';

  @override
  String get deckProfileTitle => 'Perfil do Deck';

  @override
  String get deckName => 'Nome do Deck';

  @override
  String get colorHex => 'Cor Hex';

  @override
  String get mainDeckWarning =>
      'O deck principal deve ter pelo menos 40 cartas';

  @override
  String get addToMain => 'Deck Principal';

  @override
  String get addToExtra => 'Deck Extra';

  @override
  String get save => 'Salvar';

  @override
  String get editNameTitle => 'Editar Nome do Deck';

  @override
  String get editColorTitle => 'Editar Cor do Deck';

  @override
  String get enterNewName => 'Insira novo nome';

  @override
  String get enterHexHint => 'Insira hex (ex: #1a73e8)';

  @override
  String get favouriteShort => 'Fav';

  @override
  String get wishlistShort => 'Wish';

  @override
  String get rename => 'Renomear';

  @override
  String get color => 'Cor';

  @override
  String get searchHintCatalog => 'Pesquisar...';

  @override
  String get sortName => 'Nome';

  @override
  String get sortLevel => 'Nível';

  @override
  String get sortRank => 'Rank';

  @override
  String get sortLink => 'Link';

  @override
  String get sortScale => 'Escala';

  @override
  String get sortAtk => 'ATK';

  @override
  String get sortDef => 'DEF';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterMonster => 'Monstro';

  @override
  String get filterSpell => 'Magia';

  @override
  String get filterTrap => 'Armadilha';

  @override
  String get filterExtra => 'Extra';

  @override
  String get advancedFiltersTitle => 'Filtros Avançados';

  @override
  String get close => 'Fechar';

  @override
  String get noCardsFound => 'Nenhuma carta corresponde aos filtros';

  @override
  String get clearAll => 'Limpar Tudo';

  @override
  String get apply => 'Aplicar';

  @override
  String get databaseUpdate => 'Atualização da Base de Dados';

  @override
  String get databaseVersion => 'versão_base_dados:';

  @override
  String get lastUpdate => 'última_atualização:';

  @override
  String get checkForUpdates => 'Verificar Atualizações';

  @override
  String get checkingForUpdates => 'A verificar atualizações...';

  @override
  String get dbUpdated => 'Base de dados atualizada com sucesso!';

  @override
  String get dbAlreadyUpToDate => 'A base de dados já está atualizada.';

  @override
  String get dbUpdateError => 'Falha na atualização:';

  @override
  String get maxCopiesReached => 'Você já tem 3 cópias deste card';

  @override
  String get bookmarkShort => 'Marc';

  @override
  String get viewCard => 'Ver';

  @override
  String get noItemsYet => 'Ainda sem itens. Comece a construir a sua coleção!';
}
