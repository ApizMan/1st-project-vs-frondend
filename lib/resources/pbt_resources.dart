import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/constant.dart';
import 'package:project/resources/auth/auth_resources.dart';

class PbtResources {
  static Future getPBT({
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
