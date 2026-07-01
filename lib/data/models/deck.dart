class Deck {
  final String id;
  String name;
  String colorHex;
  bool isFavourite;
  bool isWishlist;
  List<int> mainDeckCardIds;
  List<int> extraDeckCardIds;

  Deck({
    required this.id,
    required this.name,
    required this.colorHex,
    this.isFavourite = false,
    this.isWishlist = false,
    this.mainDeckCardIds = const [],
    this.extraDeckCardIds = const [],
  });

  Deck copyWith({
    String? name,
    String? colorHex,
    bool? isFavourite,
    bool? isWishlist,
    List<int>? mainDeckCardIds,
    List<int>? extraDeckCardIds,
  }) {
    return Deck(
      id: id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      isFavourite: isFavourite ?? this.isFavourite,
      isWishlist: isWishlist ?? this.isWishlist,
      mainDeckCardIds: mainDeckCardIds ?? this.mainDeckCardIds,
      extraDeckCardIds: extraDeckCardIds ?? this.extraDeckCardIds,
    );
  }

  /// To save decks
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorHex': colorHex,
    'isFavourite': isFavourite,
    'isWishlist': isWishlist,
    'mainDeckCardIds': mainDeckCardIds,
    'extraDeckCardIds': extraDeckCardIds,
  };

  /// Reconstruct them from Json
  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
    id: json['id'] as String,
    name: json['name'] as String,
    colorHex: json['colorHex'] as String,
    isFavourite: json['isFavourite'] as bool? ?? false,
    isWishlist: json['isWishlist'] as bool? ?? false,
    mainDeckCardIds: List<int>.from(json['mainDeckCardIds'] ?? []),
    extraDeckCardIds: List<int>.from(json['extraDeckCardIds'] ?? []),
  );
}