import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {

  // Singleton
  static final LocalDataService _instance = LocalDataService._internal();
  factory LocalDataService() => _instance;
  LocalDataService._internal();

  static const String remoteVersionUrl  = 'https://db.ygoprodeck.com/api/v7/checkDBVer.php';
  static const String remoteCardBaseUrl = 'https://db.ygoprodeck.com/api/v7/cardinfo.php';

  static const String keyLocalDbVersion = 'local_db_version';
  static const String keyLastUpdateDate = 'last_update_date';
  static const String keyLastVersionCheck = 'last_version_check';

  final Map<String, String> _languageFiles = {
    '': 'cardinfo.json',
    'fr': 'cardinfo_fr.json',
    'de': 'cardinfo_de.json',
    'it': 'cardinfo_it.json',
    'pt': 'cardinfo_pt.json',
  };

  /// call this once at app startup.
  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    // copy all asset files to documents if they don't exist yet
    for ( var entry in _languageFiles.entries ) {

      final localFile = File('${dir.path}/${entry.value}');

      if ( !await localFile.exists() ) {
        final assetContent = await rootBundle.loadString( 'assets/${ entry.value }' );
        await localFile.writeAsString( assetContent );
      }
    }
    // also copy checkDBVer.json
    final versionFile = File( '${ dir.path }/checkDBVer.json' );

    if ( !await versionFile.exists() ) {
      final assetContent = await rootBundle.loadString( 'assets/checkDBVer.json' );
      await versionFile.writeAsString( assetContent );
    }

    // read the local version info and store in SharedPreferences for quick access
    final localJson = jsonDecode( await versionFile.readAsString() ) as List;
    final localVersion = localJson[ 0 ][ 'database_version' ] as String;
    final localLastUpdate = localJson[ 0 ][ 'last_update' ] as String;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString( keyLocalDbVersion, localVersion );
    await prefs.setString( keyLastUpdateDate, localLastUpdate );
  }

  /// load all cards for a given language.
  /// [languageCode]: '' for English, 'fr', 'de', 'it', 'pt'.
  Future<List<dynamic>> loadCards( { String languageCode = '' } ) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = _languageFiles[ languageCode ]!;
    final file = File( '${ dir.path }/$fileName' );
    final content = await file.readAsString();
    final json = jsonDecode( content );
    return json[ 'data' ] as List<dynamic>;
  }

  /// check for updates if the last check was 24 hours ago.
  /// returns `true` if an update occorred, `false` otherwise.
  Future< bool > checkForUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheck = prefs.getInt( keyLastVersionCheck ) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    const oneDay = 24 * 60 * 60 * 1000;

    if ( now - lastCheck < oneDay ) {
      return false; 
    }

    await prefs.setInt( keyLastVersionCheck, now );

    final updated = await updateLocalDb();
    return updated;
  }

  /// check remote version and download fresh data if changed.
  /// returns `true` if an update occorred.
  /// Used directly for manual updates.
  Future<bool> updateLocalDb() async {
    final prefs = await SharedPreferences.getInstance();
    final localVersion = prefs.getString( keyLocalDbVersion );

    // cet remote version
    final versionResponse = await http.get( Uri.parse( remoteVersionUrl ) );
    
    if ( versionResponse.statusCode != 200 ) {
      return false;
    }

    final remoteData = jsonDecode( versionResponse.body ) as List;
    final remoteVersion = remoteData[ 0 ][ 'database_version' ] as String;
    final remoteLastUpdate = remoteData[ 0 ][ 'last_update' ] as String;

    if ( localVersion == remoteVersion ) {
      return false;
    }

    // download data for each language
    for ( var entry in _languageFiles.entries ) {
      final languageCode = entry.key;
      final fileName = entry.value;
      
      final url = languageCode.isEmpty
          ? Uri.parse( remoteCardBaseUrl )
          : Uri.parse( '$remoteCardBaseUrl?language=$languageCode' );

      final response = await http.get( url );

      if ( response.statusCode == 200 ) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File( '${ dir.path }/$fileName' );
        await file.writeAsString( response.body );
      }
    }

    // update local checkDBVer.json and SharedPreferences
    final dir = await getApplicationDocumentsDirectory();
    final versionFile = File( '${ dir.path }/checkDBVer.json' );

    await versionFile.writeAsString( jsonEncode( [
      { 'database_version': remoteVersion, 'last_update': remoteLastUpdate }
    ]) );
    
    await prefs.setString( keyLocalDbVersion, remoteVersion );
    await prefs.setString( keyLastUpdateDate, remoteLastUpdate );

    return true;
  }
}