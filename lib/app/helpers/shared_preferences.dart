import 'package:project/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyToken, token);
  }

  static Future<void> saveLocationDetail(
      String location, String state,String logo, int color) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyLocation, location);
    prefs.setString(keyState, state);
    prefs.setString(keyLogo, logo);
    prefs.setInt(keyColor, color);
  }

  static Future<Map<String, dynamic>> getLocationDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve values from SharedPreferences
    final String? location = prefs.getString(keyLocation);
    final String? state = prefs.getString(keyState);
    final String? logo = prefs.getString(keyLogo);
    final int? color = prefs.getInt(keyColor);

    // Return the values as a Map
    return {
      'location': location,
      'state': state,
      'logo': logo,
      'color': color,
    };
  }
}
