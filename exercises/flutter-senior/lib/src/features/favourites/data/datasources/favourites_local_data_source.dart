import 'package:shared_preferences/shared_preferences.dart';

class FavouritesLocalDataSource {
  const FavouritesLocalDataSource();

  static const String _key = 'favourites.listing_ids';

  Future<Set<String>> read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? <String>[]).toSet();
  }

  Future<void> write(Set<String> ids) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids.toList());
  }
}
