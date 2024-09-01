import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/constant.dart';
import 'package:project/resources/resources.dart';

class ParkingResources {
  static Future payment({
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