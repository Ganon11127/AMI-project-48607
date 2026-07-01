
class CardModel {
  /// [id]: card id value; 
  /// [name]: card name; 
  /// [desc]: description or effect; 
  /// [type]: spell, monster, trap;
  /// [humanReadableType]: type of card (Continuous Spell, Counter Trap, etc); 
  /// [race]: originally called type, is used to describe the type of monster's race, for example "SpellCaster". 
  /// Can also be used spells and traps, if so it will provide the type, for example "Continuous";
  /// [archetype]: if the card is in a archetype, for example "K9" is an archetype, 
  /// because there are multiple cards that have that keyword;
  /// [attribute]: if the card is a monster, it has an attribute, for example "Dark" or "Divine"
  /// [atk]: if it is a monster, it has attack;
  /// [def]: if it is a monster, it has defense;
  /// [level]: if it is a non-Link monster, it has a level OR rank;
  /// [scale]: if it is a Pendulum monster, it has a scale;
  /// [linkMarkers]: if it is a Link monster, it has arrows and if it is, for example, 
  /// a Link-2 it has arrows must have 2 values like {"Bottom", "Left"}
  /// [imageUrl]: card image in this value it's provided by the API 3 types of image: image_url, image_url_small, image_url_cropped.
  /// tecnically there can be multiple artworks of the same card, however only the first is used.
  /// [prices]: values from each market: cardmarket, tcgplayer, ebay, amazon, coolstuffinc
  /// [banlistInfo]: if card is limited in anyway in a banlist, there are multiple banlists, example {"ban_tcg": "Forbidden", "ban_ocg": "Limited"}
  /// [images]: store all image URLs
  final int id;
  final String name, desc, type; 
  final String? humanReadableType, race, archetype, attribute; 
  final int? atk, def, 
            level, link, scale;
  final List< String >? linkMarkers;
  final Map< String, String >? prices;
  final Map<String, String>? banlistInfo;
  final List< Map< String, String > > images; 

  CardModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.type,
    this.humanReadableType,
    this.race,
    this.archetype,
    this.atk,
    this.def,
    this.level,
    this.attribute,
    this.link,
    this.linkMarkers,
    this.scale,
    this.prices,
    this.banlistInfo,
    required this.images,
  });

  /// getter for first image
  String get mainImageUrl => images.isNotEmpty ? images[ 0 ][ 'full' ]! : '';
  /// getter for second image image
  String get smallImageUrl => images.isNotEmpty ? images[ 0 ][ 'small' ]! : '';

  factory CardModel.fromJson( Map< String, dynamic > json ) {

    // get all images
    List< Map< String, String > > imageList = [];
    final imagesJson = json[ 'card_images' ] as List?;

    if ( imagesJson != null ) {
      for ( var img in imagesJson ) {
        imageList.add({
          'full': img[ 'image_url' ] as String,
          'small': img[ 'image_url_small' ] as String,
          'cropped': img[ 'image_url_cropped' ] as String,
        });
      }
    }

    Map<String, String>? banlist;
    final banlistJson = json['banlist_info'] as Map<String, dynamic>?;
    if (banlistJson != null) {
      banlist = {};
      banlistJson.forEach((key, value) {
        banlist![key] = value.toString();
      });
    }

    // get card_prices array
    Map< String, String >? priceMap;
    final pricesJson = json[ 'card_prices' ] as List?;

    if ( pricesJson != null && pricesJson.isNotEmpty ) {
      final prices = pricesJson[ 0 ];
      priceMap = {
        'cardmarket': prices[ 'cardmarket_price' ]?.toString() ?? '0',
        'tcgplayer': prices[ 'tcgplayer_price' ]?.toString() ?? '0',
        'coolstuffinc': prices[ 'coolstuffinc_price' ]?.toString() ?? '0',
        'ebay': prices[ 'ebay_price' ]?.toString() ?? '0',
        'amazon': prices[ 'amazon_price' ]?.toString() ?? '0'
      };
    }

    // get linkmarkers array
    List< String >? markers;
    final markersRaw = json[ 'linkmarkers' ];

    if ( markersRaw is List ) {
      markers = markersRaw.map( ( e ) => e.toString() ).toList();
    }

    return CardModel(
      id: json[ 'id' ] as int,
      name: json[ 'name' ] as String,
      desc: json[ 'desc' ] as String,
      type: json[ 'type' ] as String,
      humanReadableType: json[ 'humanReadableCardType' ] as String?,
      race: json[ 'race' ] as String?,
      archetype: json[ 'archetype' ] as String?,
      atk: json[ 'atk' ] as int?,
      def: json[ 'def' ] as int?,
      level: json[ 'level' ] as int?,
      link: json[ 'link' ] as int?,
      scale: json[ 'scale' ] as int?,
      attribute: json[ 'attribute' ] as String?,
      linkMarkers: markers,
      prices: priceMap,
      banlistInfo: banlist,
      images: imageList,
    );
}

}