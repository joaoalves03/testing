import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class SharedPrefsUtil {
  static final Logger logger = Logger();

  static Future<void> initializeDefaults() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('theme')) {
      await prefs.setString('theme', 'light');
    }

    if (!prefs.containsKey('color_scheme')) {
      await prefs.setString('color_scheme', 'school');
    }

    if (!prefs.containsKey('school_theme')) {
      await prefs.setString('school_theme', 'IPVC');
    }

    SharedPrefsUtil.printPrefs();
  }

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
