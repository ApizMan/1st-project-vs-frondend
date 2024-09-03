import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:project/component/generate_qr.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/component/paymentGateway.dart';
import 'package:project/component/receipt_screen.dart';
import 'package:project/component/webview.dart';
import 'package:project/constant.dart';
import 'package:project/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final UserModel userProfile;
  const PaymentScreen({super.key, required this.userProfile});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _currentDate = ''; // Initialize variable for date
  // ignore: unused_field
  String? _qrCodeUrl;
  String? shortcutLink;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => updateDateTime());
  }

  void updateDateTime() {
    setState(() {
      _currentDate =
          DateTime.now().toString().split(' ')[0]; // Get current date
    });
  }

  Future<void> peymentplatformone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.post(
      Uri.parse("$baseUrl/payment/generate-qr"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'order_amount': GlobalState.amount,
        'store_id': 'Token', //description
        'terminal_id': widget.userProfile.firstName, //email
        'shift_id': widget.userProfile.email, //city
      }),
    );

    if (kDebugMode) {
      print('response.body : ${response.body}');
    }
    print('response.body : ${response.statusCode}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final qrCodeUrl = jsonResponse['content']['qr'];
      if (qrCodeUrl != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QrCodeScreen(qrCodeUrl: qrCodeUrl),
          ),
        );
      }
    }
  }

  Future<void> peymentplatformtwo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.post(
      Uri.parse("$baseUrl/paymentfpx/recordBill-token/"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'NetAmount': GlobalState.amount,
      }),
    );

    if (kDebugMode) {
      print('response.body : ${response.body}');
    }
    print('response.body : ${response.statusCode}');
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Payment Successful!');
      }

      final responseData = jsonDecode(response.body);
      final String shortcutLink = responseData['ShortcutLink'];

      if (kDebugMode) {
        print('shortcutLink: $shortcutLink');
      }

      // Navigate to the WebView page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(url: shortcutLink),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
        leading: SizedBox(
          child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.white,
              )),
        ),
        title: Text(
          'Back',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Payment',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Name',
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      '${widget.userProfile.firstName} ${widget.userProfile.secondName}',
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Date',
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      _currentDate,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Email',
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      widget.userProfile.email!,
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      'Token',
                      style: GoogleFonts.firaCode(),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      'RM ${GlobalState.amount.toStringAsFixed(2)}',
                      style: GoogleFonts.firaCode(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Please Pay and Park Responsibly',
                  style: GoogleFonts.firaCode(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              const Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      peymentplatformone();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets_images/duitnow.png'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              peymentplatformtwo();
                            },
                            child: Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage('assets_images/fpx.png'),
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                          if (shortcutLink != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Shortcut Link: $shortcutLink',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline, // Icon yang ingin Anda gunakan
                      color: Colors.red, // Warna ikon
                    ),
                    const SizedBox(height: 50),
                    const SizedBox(width: 5), // Jarak antara ikon dan teks
                    Flexible(
                      child: Text(
                        'You will be bring to 3rd Party website for Reload Token. Please ensure the detail above is accurate.',
                        style: GoogleFonts.firaCode(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: SizedBox(
                  width: 100,
                  height: 25,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReceiptScreen(
                            userProfile: widget.userProfile,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: Text(
                      'PAY',
                      style: GoogleFonts.nunitoSans(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
