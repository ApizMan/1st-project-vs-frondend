import 'package:project/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveLanguage(String defaultLanguage) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(keyLanguage, defaultLanguage);
  }
  
  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyToken, token);
  }

  static Future<void> saveLocationDetail(
      {String location = 'PBT Kuantan',
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
      {required String duration, required bool isUpdate}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(durationKey, duration);
    await prefs.setBool(isUpdateKey, isUpdate);
  }

  static Future<String> getParkingDuration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? duration = prefs.getString(durationKey);

    return duration ?? '00:00:00';
  }

  static Future<bool> getDurationUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? duration = prefs.getBool(isUpdateKey);

    return duration ?? false;
  }

  static Future<void> setReloadAmount(
      {double amount = 0.00,
      String carPlate = '',
      String monthlyDuration = ''}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(amountReloadKey, amount);
    prefs.setString(carPlateKey, carPlate);
    prefs.setString(monthlyDurationKey, monthlyDuration);
  }

  static Future<double> getReloadAmount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double amount = prefs.getDouble(amountReloadKey) ?? 0.00;

    return amount;
  }

  static Future<String> getCarPlate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String carPlate = prefs.getString(carPlateKey) ?? '';

    return carPlate;
  }

  static Future<String> getMonthlyDuration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String duration = prefs.getString(monthlyDurationKey) ?? '';

    return duration;
  }

// Method to set order details
  static Future<void> setOrderDetails({
    String orderNo = '',
    String amount = '',
    String status = '',
    String storeId = '',
    String shiftId = '',
    String terminalId = '',
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save all the details in SharedPreferences
    prefs.setString(orderNoKey, orderNo);
    prefs.setString(orderAmountKey, amount);
    prefs.setString(orderStatusKey, status);
    prefs.setString(orderStoreIdKey, storeId);
    prefs.setString(orderShiftIdKey, shiftId);
    prefs.setString(orderTerminalIdKey, terminalId);
  }

// Method to get order details
  static Future<Map<String, dynamic>> getOrderDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve all the details from SharedPreferences
    String orderNo = prefs.getString(orderNoKey) ?? '';
    String amount = prefs.getString(orderAmountKey) ?? '';
    String status = prefs.getString(orderStatusKey) ?? '';
    String storeId = prefs.getString(orderStoreIdKey) ?? '';
    String shiftId = prefs.getString(orderShiftIdKey) ?? '';
    String terminalId = prefs.getString(orderTerminalIdKey) ?? '';

    // Return the details as a map
    return {
      'orderNo': orderNo,
      'amount': amount,
      'status': status,
      'storeId': storeId,
      'shiftId': shiftId,
      'terminalId': terminalId,
    };
  }
}
