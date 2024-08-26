import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> payKey() async {
  var url = Uri.parse("https://pegepay.com/api/onboard-merchant");

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      {
        "onboarding_key": "MWZJQRSD", 
        "connection_type": "npd-wa"
      }
    }),
  );
  if (response.statusCode == 200) {
    print('Onboarding Key Succesful!');
  } else {
    print('Onboarding Key failed: ${response.statusCode}');
    print('Response: ${response.body}');
  }
}
