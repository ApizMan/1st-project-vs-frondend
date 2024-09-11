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

  static Future<void> setPaymentStatus({bool paymentStatus = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(paymentStatusKey, paymentStatus);
  }

  static Future<bool> getPaymentStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool paymentStatus = prefs.getBool(paymentStatusKey) ?? false;

    return paymentStatus;
  }

  static Future<void> setParkingDuration(
      {String duration = '00:00:00', bool isUpdate = false}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(durationKey, duration);
    prefs.setBool(isUpdateKey, isUpdate);
  }

  static Future<String> getParkingDuration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String duration = prefs.getString(durationKey) ?? '00:00:00';

    return duration;
  }

  static Future<bool> getDurationUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool duration = prefs.getBool(isUpdateKey) ?? false;

    return duration;
  }
}
