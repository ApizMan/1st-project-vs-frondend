import 'dart:convert';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/login_screen.dart';
import 'package:project/constant.dart';
import 'package:project/widget/UserProvider.dart';
//import 'package:project/component/encrypt.dart';
import 'package:project/widget/background_image_signup.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  var _password = '';
  // ignore: non_constant_identifier_names
  TextEditingController first_name = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController last_name = TextEditingController();
  TextEditingController id_number = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController address3 = TextEditingController();
  TextEditingController postcode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController carplate = TextEditingController();
  late UserProvider userProvider;
  final PageController _pageController = PageController(initialPage: 0);
  bool rememberMe = false;
  String _errorMessage = '';
  bool _isValid = false;
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  void _toggleRememberMe() {
    setState(() {
      rememberMe = !rememberMe;
    });
  }

  Future<void> signup() async {
    var url = Uri.parse("$baseUrl/auth/signup");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstName': first_name.text,
        'secondName': last_name.text,
        'idNumber': id_number.text,
        'phoneNumber': phonenumber.text,
        'email': email.text,
        'password': _passwordController.text,
        // 'confirmpassword': confirmpassword.text,
        'address1': address1.text,
        'address2': address2.text,
        'address3': address3.text,
        'postcode': int.parse(postcode.text),
        'city': city.text,
        'state': state.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Signup Succesful!');
    } else {
      print('Signup failed: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    userProvider = UserProvider();
    passwordVisible = true;
    passwordVisible2 = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            BackgroundImage_signup(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create',
                      style: GoogleFonts.secularOne(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'New Account',
                      style: GoogleFonts.secularOne(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Registered?",
                          style: GoogleFonts.secularOne(
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (e) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "Login Here",
                            style: GoogleFonts.secularOne(
                              color: const Color.fromARGB(255, 30, 6, 207),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          width: 300,
                          height: 450,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {},
                            children: [
                              _buildAccountPage(),
                              _buildAddressPage(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountPage() {
    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(height: 35),
        Container(
          width: 250,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextField(
            controller: first_name,
            decoration: InputDecoration(
              labelText: null,
              hintText: 'First Name',
              hintStyle: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 250, // Set the desired width
          height: 25, // Set the desired height
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD), // Set the desired background color
            borderRadius:
                BorderRadius.circular(40), // Set the desired border radius
          ),
          child: TextField(
            controller: last_name,
            decoration: InputDecoration(
              labelText: null,
              hintText: 'Second Name',
              hintStyle: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 250, // Set the desired width
          height: 30, // Set the desired height
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD), // Set the desired background color
            borderRadius:
                BorderRadius.circular(40), // Set the desired border radius
          ),
          child: TextField(
            controller: id_number,
            decoration: InputDecoration(
              labelText: null,
              hintText: 'I.D NUMBER',
              hintStyle: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 250, // Set the desired width
          height: 30, // Set the desired height
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD), // Set the desired background color
            borderRadius:
                BorderRadius.circular(40), // Set the desired border radius
          ),
          child: TextField(
            controller: phonenumber,
            decoration: InputDecoration(
              labelText: null,
              hintText: 'PHONE NUMBER',
              hintStyle: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 250, // Set the desired width
          height: 30, // Set the desired height
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD), // Set the desired background color
            borderRadius:
                BorderRadius.circular(40), // Set the desired border radius
          ),
          child: TextField(
            controller: email,
            decoration: InputDecoration(
              labelText: null,
              hintText: 'E-MAIL',
              hintStyle: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 250, // Set the desired width
          height: 30, // Set the desired height
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD), // Set the desired background color
            borderRadius:
                BorderRadius.circular(40), // Set the desired border radius
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: passwordVisible,
            decoration: InputDecoration(
              labelText: null,
              hintText: 'PASSWORD',
              hintStyle: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
          ),
        ),
        const SizedBox(height: 5),
        if (_isValid)
          const Text('Password is valid', style: TextStyle(color: Colors.green))
        else if (_errorMessage.isNotEmpty)
          Text(
            'Password is not valid \n $_errorMessage',
            style: const TextStyle(color: Colors.red),
          ),
        const SizedBox(height: 20),
        Container(
          width: 250, // Set the desired width
          height: 30, // Set the desired height
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD), // Set the desired background color
            borderRadius:
                BorderRadius.circular(40), // Set the desired border radius
          ),
          child: TextFormField(
            controller: confirmpassword,
            obscureText: passwordVisible2,
            decoration: InputDecoration(
              labelText: null,
              hintText: 'CONFIRM PASSWORD',
              hintStyle: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                    passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                    size: 15),
                onPressed: () {
                  setState(() {
                    passwordVisible2 = !passwordVisible2;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(40),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 250,
          height: 30,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isValid = _validatePassword(_passwordController.text);
                if (_isValid) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 55, 26, 250),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)) // Background color
                ),
            child: Text(
              'Next',
              style: GoogleFonts.nunitoSans(color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildAddressPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 250, // Set the desired width
            height: 30, // Set the desired height
            decoration: BoxDecoration(
              color:
                  const Color(0xFFDDDDDD), // Set the desired background color
              borderRadius:
                  BorderRadius.circular(40), // Set the desired border radius
            ),
            child: TextField(
              controller: address1,
              decoration: InputDecoration(
                labelText: null,
                hintText: 'ADDRESS 1',
                hintStyle: GoogleFonts.dmSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250, // Set the desired width
            height: 30, // Set the desired height
            decoration: BoxDecoration(
              color:
                  const Color(0xFFDDDDDD), // Set the desired background color
              borderRadius:
                  BorderRadius.circular(40), // Set the desired border radius
            ),
            child: TextField(
              controller: address2,
              decoration: InputDecoration(
                labelText: null,
                hintText: 'ADDRESS 2',
                hintStyle: GoogleFonts.dmSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250, // Set the desired width
            height: 30, // Set the desired height
            decoration: BoxDecoration(
              color:
                  const Color(0xFFDDDDDD), // Set the desired background color
              borderRadius:
                  BorderRadius.circular(40), // Set the desired border radius
            ),
            child: TextField(
              controller: address3,
              decoration: InputDecoration(
                labelText: null,
                hintText: 'ADDRESS 3',
                hintStyle: GoogleFonts.dmSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250, // Set the desired width
            height: 30, // Set the desired height
            decoration: BoxDecoration(
              color:
                  const Color(0xFFDDDDDD), // Set the desired background color
              borderRadius:
                  BorderRadius.circular(40), // Set the desired border radius
            ),
            child: TextField(
              controller: postcode,
              decoration: InputDecoration(
                labelText: null,
                hintText: 'POSTCODE',
                hintStyle: GoogleFonts.dmSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250, // Set the desired width
            height: 30, // Set the desired height
            decoration: BoxDecoration(
              color:
                  const Color(0xFFDDDDDD), // Set the desired background color
              borderRadius:
                  BorderRadius.circular(40), // Set the desired border radius
            ),
            child: TextField(
              controller: city,
              decoration: InputDecoration(
                labelText: null,
                hintText: 'CITY',
                hintStyle: GoogleFonts.dmSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextField(
              controller: state,
              decoration: InputDecoration(
                labelText: null,
                hintText: 'STATE',
                hintStyle: GoogleFonts.dmSans(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),
          if (_isValid)
            const Text('Password is valid',
                style: TextStyle(color: Colors.green))
          else if (_errorMessage.isNotEmpty)
            Text(
              'Password is not valid \n $_errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
          Row(children: [
            Checkbox(
                value: rememberMe,
                onChanged: (((value) {
                  setState(() {
                    rememberMe = value!;
                  });
                }))),
            Text(
              "I understand to the Term & Conditions",
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ]),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 250,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    signup();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 26, 200),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.nunitoSans(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _validatePassword(String password) {
    _errorMessage = '';

    if (password.length < 6) {
      _errorMessage += 'Password must be at least 6 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Uppercase letter is missing.\n';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage += '• Lowercase letter is missing.\n';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage += '• Digit is missing.\n';
    }

    if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      _errorMessage += '• Special character is missing.\n';
    }

    return _errorMessage.isEmpty;
  }
}
