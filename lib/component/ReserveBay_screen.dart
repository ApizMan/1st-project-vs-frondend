import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/component/home_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ReserveBay extends StatefulWidget {
  const ReserveBay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReserveBayState createState() => _ReserveBayState();
}

class _ReserveBayState extends State<ReserveBay> {
  final PageController _pageController = PageController(initialPage: 0);

  // ignore: non_constant_identifier_names
  TextEditingController Company_name = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController company_regis = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController bussines_type = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController Address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController address3 = TextEditingController();
  TextEditingController postcode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController pic1 = TextEditingController();
  TextEditingController pic2 = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController idnumber = TextEditingController();
  TextEditingController phonenum = TextEditingController();
  TextEditingController totallot = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController lotnum = TextEditingController();
  TextEditingController loc = TextEditingController();

  void uploadPdf() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();

    if (resultFile != null) {
      PlatformFile file = resultFile.files.first;
      print(file.name);
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final List<Placemark> locationName = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        loc.text = locationName.first.locality.toString();
      });
    } catch (e) {
      // Handle the exception as needed, for example by showing a message to the user
      print('Error occurred while getting location: $e');
    }
  }

  Future<void> createReserveBay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("http://192.168.0.119:3000/reservebay/create");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'companyName': Company_name.text,
        'companyRegistration': company_regis.text,
        'businessType': bussines_type.text,
        'address1': Address1.text,
        'address2': address2.text,
        'address3': address3.text,
        'postcode': postcode.text,
        'city': city.text,
        'picFirstName': pic1.text,
        'picLastName': pic2.text,
        'idNumber': idnumber.text,
        'email': email.text,
        'phoneNumber': phonenum.text,
        'totalLotRequired': int.parse(totallot.text),
        'reason': reason.text,
        'lotNumber': lotnum.text,
        'location': loc.text,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reserve Bay',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Image(
                    image: AssetImage('assets_images/Reserve_bay.png'),
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            )),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          Center(
              child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: Company_name,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'Company Name*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: company_regis,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'Company Registration No. (SSM)*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: bussines_type,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'Bussines Type*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: Address1,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'Address 1*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: address2,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'Address 2*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: address3,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'Address 3*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: postcode,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'Postcode*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: city,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'City*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 300, // Set the desired width
                height: 35, // Set the desired height
                decoration: BoxDecoration(
                  color: const Color(
                      0xFFDDDDDD), // Set the desired background color
                  borderRadius: BorderRadius.circular(
                      40), // Set the desired border radius
                ),
                child: TextField(
                  controller: state,
                  decoration: InputDecoration(
                    labelText: null,
                    hintText: 'State*',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 26, 200),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20)) // Background color
                      ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.nunitoSans(color: Colors.white),
                  ),
                ),
              )
            ]),
          )),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: pic1,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'Person In Charge (First Name)*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: pic2,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'Person In Charge (Last Name)*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: phonenum,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'Phone Number*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'Email*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: totallot,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'Total Lot Required*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: idnumber,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'I.D Number*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: reason,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'Reason*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: lotnum,
                      decoration: InputDecoration(
                        labelText: null,
                        hintText: 'Lot Number*',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300, // Set the desired width
                    height: 35, // Set the desired height
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          40), // Set the desired border radius
                    ),
                    child: TextField(
                      controller: loc,
                      decoration: InputDecoration(
                          labelText: null,
                          hintText: 'Location*',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          suffixIcon: Icon(
                            Icons.location_on,
                            color: Colors.red[900],
                          )),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 55, 26, 200),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20)) // Background color
                            ),
                        child: Text(
                          'Back',
                          style: GoogleFonts.nunitoSans(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 55, 26, 200),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20)) // Background color
                            ),
                        child: Text(
                          'Next',
                          style: GoogleFonts.nunitoSans(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Intended Designated Bays (Front)*',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 26, 21, 169),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Container(
                    width: 250,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFDDDDDD), // Set the desired background color
                      borderRadius: BorderRadius.circular(
                          20), // Set the desired border radius
                    ),
                    child: IconButton(
                      onPressed: () {
                        uploadPdf();
                      },
                      icon: const Icon(Icons.upload),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Company Registration Certificate*',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 26, 21, 169),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 250,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(
                        0xFFDDDDDD), // Set the desired background color
                    borderRadius: BorderRadius.circular(
                        20), // Set the desired border radius
                  ),
                  child: IconButton(
                    onPressed: () {
                      uploadPdf();
                    },
                    icon: const Icon(Icons.upload),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Identification Card (Front & Back)',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 26, 21, 169),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 250,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(
                        0xFFDDDDDD), // Set the desired background color
                    borderRadius: BorderRadius.circular(
                        20), // Set the desired border radius
                  ),
                  child: IconButton(
                    onPressed: () {
                      uploadPdf();
                    },
                    icon: const Icon(Icons.upload),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 55, 26, 200),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20)) // Background color
                          ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.nunitoSans(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        createReserveBay();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 55, 26, 200),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20)) // Background color
                          ),
                      child: Text(
                        'Submit',
                        style: GoogleFonts.nunitoSans(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Assuming you have a function to handle the submit button press
}
