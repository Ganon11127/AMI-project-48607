import 'package:flutter/foundation.dart';
import '../data/models/bottom_nav_model.dart';

class NavigationViewModel extends ChangeNotifier {
  static const List<BottomNavModel> _items = [
    //BottomNavModel( iconData: 'test', label: 'bottomNavCatalog' ),
    BottomNavModel( iconData: 'decks', label: 'bottomNavDeck' ),
    BottomNavModel( iconData: 'home', label: 'bottomNavHome' ),
    BottomNavModel( iconData: 'translate', label: 'bottomNavTranslation' ),
    BottomNavModel( iconData: 'battle', label: 'bottomNavBattle' ),
  ];

  List<BottomNavModel> get items => _items;
  
  int getIndexOfKey( String key ) {
    return _items.indexWhere( ( item ) => item.label == key );
  }

  static String routeFromKey( String key ) {
    switch ( key ) {
      case 'bottomNavHome': return '/';
      case 'bottomNavCatalog': return '/catalog';
      case 'bottomNavDeck': return '/deck';
      case 'bottomNavTranslation': return '/translation';
      case 'bottomNavBattle': return '/battle';
      default: return '/';
    }
  }
}