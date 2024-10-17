import 'dart:convert';

import 'package:project/constant.dart';
import 'package:http/http.dart' as http;
import 'package:project/resources/resources.dart';

class PromotionsResources {
  static Future getPromotionMonthlyPass({
    required String prefix,
  }) async {
    var response = await http.get(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }

  static Future getPromotionHistory({
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
