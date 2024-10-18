import 'dart:convert';

import 'package:project/constant.dart';
import 'package:project/resources/resources.dart';
import 'package:http/http.dart' as http;

class NotificationsResources {
  static Future getNotifications({
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

  static Future readNotification({
    required String prefix,
  }) async {
    final token = await AuthResources.getToken();
    var response = await http.put(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }
}
