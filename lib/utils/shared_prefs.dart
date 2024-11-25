import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SharedPrefsUtil {
  static final Logger logger = Logger();

  static Future<void> printPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, Object> allPrefs =
        prefs.getKeys().fold<Map<String, Object>>({}, (map, key) {
      map[key] = prefs.get(key) as Object;
      return map;
    });

    logger.d(allPrefs);
  }
}
