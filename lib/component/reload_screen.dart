import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/component/payment_screen.dart';
import 'package:project/constant.dart';
//import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReloadCreditScreen extends StatefulWidget {
  final UserProfile userProfile;
  const ReloadCreditScreen({super.key, required this.userProfile});
  @override
  State<ReloadCreditScreen> createState() => _ReloadCreditScreenState();
}

class GlobalState { 
  static double amount = 0.0;  
}

class _ReloadCreditScreenState extends State<ReloadCreditScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '00.00');
  }

  Future <void> reloadMoney() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse("$baseUrl/payment/topup-wallet");

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "amount": double.parse(_controller.text),   
      }),
    );

    if (response.statusCode == 200) {
      print('Reload Succesful!');
    } else {
      print('Reload failed: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reload',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.refresh,
                    size: 60,
                    color: Colors.white,
                  ),
                ],
              ),
            )),
        backgroundColor: const Color.fromARGB(255, 55, 26, 200),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            Text(
              'A M O U N T (RM)',
              style: GoogleFonts.dmSans(
                color: const Color.fromARGB(255, 31, 36, 132),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 200,
              height: 50,
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  color: Color.fromARGB(255, 31, 36, 132),
                  fontSize: 15,                  
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),                  
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),               
                ),
              ),
            ),
          ]),
          const SizedBox(height: 50),
          Column(
            children: [
              Text(
                'A M O U N T (Token)',
                style: GoogleFonts.dmSans(
                  color: const Color.fromARGB(255, 31, 36, 132),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 15),
                SizedBox(
              width: 200,
              height: 50,
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  color: Color.fromARGB(255, 31, 36, 132),
                  fontSize: 15,                  
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),                  
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),               
                ),
              ),
            ),
            ],
          ),
          const SizedBox(height: 50),
          Center(
            child: SizedBox(
              width: 100,
              height: 25,
              child: ElevatedButton(
                onPressed: () {
                  //reloadMoney();
                  Navigator.of(context).push(MaterialPageRoute( builder: (context) =>  PaymentScreen(userProfile: widget.userProfile)));
                  GlobalState.amount = double.parse(_controller.text);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 55, 26, 200),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5)) // Background color
                    ),
                child: Text(
                  'Confirm',
                  style: GoogleFonts.nunitoSans(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
