import 'dart:convert';

import 'package:project/constant.dart';
import 'package:project/resources/resources.dart';
import 'package:http/http.dart' as http;

class ReloadResources {
  static Future reloadMoneyPageypay({
    required String prefix,
    required Object body,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future reloadMoneyFPX({
    required String prefix,
    required Object body,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future reloadProcess({
    required String prefix,
    required Object body,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future reloadSuccessful({
    required String prefix,
    required Object body,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }
}