import 'package:project/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyToken, token);
  }

  static Future<void> saveLocationDetail(
      {String location = 'Majlis Bandaraya Kuantan',
      String state = 'Pahang',
      String logo = kuantanLogo,
      int? color}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyLocation, location);
    prefs.setString(keyState, state);
    prefs.setString(keyLogo, logo);
    prefs.setInt(keyColor, color ?? kPrimaryColor.value);
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

  static Future<void> setDefaultSetting(bool isFirstRun) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isFirstRunKey, isFirstRun);
  }

  static Future<bool> getDefaultSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool(isFirstRunKey) ?? true;

    return isFirstRun;
  }

  static Future<void> setPayment(String setPayment) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(setPayment, paymentKey);
  }

  static Future<String> getPayment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String paymentStatus = prefs.getString(paymentKey)!;

    return paymentStatus;
  }
}
