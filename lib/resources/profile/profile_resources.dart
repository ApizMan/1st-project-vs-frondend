import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/constant.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileResources {
  static Future getProfile({
    required String prefix,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.get(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future updateProfile({
    required String prefix,
    required Object body,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.put(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future getCarPlateNumbers({
    required String prefix,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.get(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future getTransactionHistory({
    required String prefix,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.get(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future getTransactionWallet({
    required String prefix,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.get(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }
}
