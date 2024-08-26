import 'dart:convert';
import 'package:http/http.dart' as http;

get prefs => null;
Future<String> fetchName() async {   
String? token = prefs.getString('token');
  final response = await http.get(Uri.parse("http://localhost:3000/auth/userprofile"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );  

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['name'];   
  } else {
   throw Exception('Failed to fetch user profile. Status code: ${response.statusCode}');
  }
}