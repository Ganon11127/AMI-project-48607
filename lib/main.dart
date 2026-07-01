import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yu_gi_oh_app/data/repositories/card_repository.dart';
import 'package:yu_gi_oh_app/data/services/api/favourites_service.dart';
import 'package:yu_gi_oh_app/data/services/api/local_data_service.dart';
import 'package:yu_gi_oh_app/data/services/api/user_settings.dart';
import 'package:yu_gi_oh_app/data/services/camera/camera_handler.dart';
import 'package:yu_gi_oh_app/data/services/camera/camera_handler_impl.dart';
import 'package:yu_gi_oh_app/data/services/text_recognition/text_recognition_impl.dart';
import 'package:yu_gi_oh_app/data/repositories/deck_repository.dart';
import 'package:yu_gi_oh_app/data/repositories/card_repository_interface.dart';

// New services
import 'package:yu_gi_oh_app/data/services/text_recognition/text_recognition_service.dart';
import 'package:yu_gi_oh_app/data/services/sensors/sensor_service.dart';
import 'package:yu_gi_oh_app/data/services/sensors/sensor_service_impl.dart';
import 'package:yu_gi_oh_app/data/services/card_search/card_search_service.dart';
import 'package:yu_gi_oh_app/data/services/card_search/card_search_service_impl.dart';

// ViewModels
import 'package:yu_gi_oh_app/viewmodel/navigation_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/home_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/settings_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/theme_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/app_language_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/battle_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/translation_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/deck_viewmodel.dart';
import 'package:yu_gi_oh_app/viewmodel/deck_profile_viewmodel.dart';

// Screens
import 'package:yu_gi_oh_app/ui/screens/home_screen.dart';
import 'package:yu_gi_oh_app/ui/screens/settings_screen.dart';
import 'package:yu_gi_oh_app/ui/screens/battle_screen.dart';
import 'package:yu_gi_oh_app/ui/screens/translation_screen.dart';
import 'package:yu_gi_oh_app/ui/screens/to_be_removed_catalog_screen.dart';
import 'package:yu_gi_oh_app/ui/screens/deck_list_screen.dart';
import 'package:yu_gi_oh_app/ui/screens/deck_profile_screen.dart';

// Localization
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';

// Theme
import 'package:yu_gi_oh_app/ui/theme/app_theme.dart';

// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';
import 'package:yu_gi_oh_app/debug/debug_panel.dart';
import 'package:path_provider/path_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  final prefs = await SharedPreferences.getInstance();
  final userSettings = UserSettings();
  await userSettings.setTargetLanguage(''); // default to English

  final localDataService = LocalDataService();
  await localDataService.initialize();
  localDataService.checkForUpdates().then((updated) {
    if (updated) debugPrint('Database updated');
  });

  final deckRepository = DeckRepository(prefs);
  final favouritesService = FavouritesService(prefs);
  final cardRepository = CardRepositoryImp(localDataService);

  // Instantiate new services
  final cameraHandler = CameraHandlerImpl();
  final textRecognitionService = TextRecognitionServiceImpl();
  final sensorService = SensorServiceImpl();
  final cardSearchService = CardSearchServiceImpl(cardRepository, userSettings);

  await DebugLogger().init();
  final dir = await getApplicationDocumentsDirectory();
  debugPrint('Logs saved in: ${dir.path}');

  runApp(
    MultiProvider(
      providers: [
        // ViewModels that depend on services
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewmodel()),
        ChangeNotifierProvider(create: (_) => AppLanguageViewmodel()),
        ChangeNotifierProvider(
          create: (_) => DeckViewModel(deckRepository, favouritesService),
        ),
        ChangeNotifierProvider(
          create: (_) => BattleViewModel(sensorService),
        ),
        ChangeNotifierProvider(
          create: (_) => TranslationViewModel(
            cameraHandler: cameraHandler,
            textRecognitionService: textRecognitionService,
            cardSearchService: cardSearchService,
          ),
        ),
        // Repositories and services as providers
        Provider<DeckRepository>(create: (_) => deckRepository),
        Provider<FavouritesService>(create: (_) => favouritesService),
        ChangeNotifierProvider<UserSettings>(create: (_) => userSettings),
        Provider<CardRepository>(create: (_) => cardRepository),

        // HomeViewModel needs these dependencies
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            deckRepository: context.read<DeckRepository>(),
            cardRepository: context.read<CardRepository>(),
            favouritesService: context.read<FavouritesService>(),
            userSettings: context.read<UserSettings>(),
          ),
        ),
        // Provide services directly if needed elsewhere
        Provider<CameraHandler>(create: (_) => cameraHandler),
        Provider<TextRecognitionService>(create: (_) => textRecognitionService),
        Provider<SensorService>(create: (_) => sensorService),
        Provider<CardSearchService>(create: (_) => cardSearchService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static int _tapCount = 0;
  static DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    final appLanguage = context.watch<AppLanguageViewmodel>().appLanguage;
    final themeMode = context.watch<ThemeViewmodel>().themeMode;

    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: appLanguage,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
      ],
      title: 'Yu-Gi-Oh App',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      initialRoute: '/',
      navigatorObservers: [
        _NavigationObserver(),
      ],
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: const RouteSettings(name: 'HomeScreen'),
              builder: (_) => const HomeScreen(),
            );
          case '/catalog':
            return MaterialPageRoute(
              settings: const RouteSettings(name: 'CatalogScreen'),
              builder: (_) => const CatalogScreen(),
            );
          case '/deck':
            return MaterialPageRoute(
              settings: const RouteSettings(name: 'DeckListScreen'),
              builder: (_) => const DeckListScreen(),
            );
          case '/deckProfile':
            final deckId = settings.arguments as String?;
            return MaterialPageRoute(
              settings: RouteSettings(name: 'DeckProfileScreen', arguments: deckId),
              builder: (context) => ChangeNotifierProvider(
                create: (_) => DeckProfileViewModel(
                  deckRepository: context.read<DeckRepository>(),
                  cardRepository: context.read<CardRepository>(),
                  userSettings: context.read<UserSettings>(),
                  favouritesService: context.read<FavouritesService>(),
                  deckId: deckId,
                ),
                child: const DeckProfileScreen(),
              ),
            );
          case '/translation':
            return MaterialPageRoute(
              settings: const RouteSettings(name: 'TranslationScreen'),
              builder: (_) => const TranslationScreen(),
            );
          case '/battle':
            return MaterialPageRoute(
              settings: const RouteSettings(name: 'BattleScreen'),
              builder: (_) => const BattleScreen(),
            );
          case '/settings':
            return MaterialPageRoute(
              settings: const RouteSettings(name: 'SettingsScreen'),
              builder: (_) => const SettingsScreen(),
            );
          default:
            return MaterialPageRoute(
              settings: const RouteSettings(name: 'HomeScreen'),
              builder: (_) => const HomeScreen(),
            );
        }
      },
      builder: (context, child) {
        return Listener(
          onPointerDown: (event) {
            DebugLogger().logTap();

            final size = MediaQuery.of(context).size;
            final dx = event.position.dx;
            final dy = event.position.dy;

            if (dy < 150 && dx > size.width / 2 - 180 && dx < size.width / 2 + 180) {
              _handleTitleTap(context);
            }
          },
          child: child!,
        );
      },
    );
  }

  void _handleTitleTap(BuildContext context) {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds > 800) {
      _tapCount = 0;
    }
    _lastTapTime = now;
    _tapCount++;

    if (_tapCount == 3) {
      _tapCount = 0;
      _showDebugPanel();
    }
  }

  void _showDebugPanel() {
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DebugPanel(),
    );
  }
}

class _NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final screenName = route.settings.name ?? route.runtimeType.toString();
    DebugLogger().logNavigation(screenName);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final screenName = newRoute?.settings.name ?? newRoute?.runtimeType.toString() ?? 'unknown';
    DebugLogger().logNavigation(screenName);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final screenName = previousRoute?.settings.name ?? previousRoute?.runtimeType.toString() ?? 'unknown';
    DebugLogger().logNavigation(screenName);
    super.didPop(route, previousRoute);
  }
}