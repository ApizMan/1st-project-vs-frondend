import 'package:project/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageResources {
  // Share Preferences
  static Future<String?> getLanguage() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(keyLanguage);
  }
}