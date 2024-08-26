import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:project/constant.dart';

class AuthResources {
  static Future login({
    required String prefix,
    required Object body,
  }) async {
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }
}
