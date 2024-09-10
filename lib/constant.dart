// Base URL
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// const String baseUrl = 'http://192.168.0.128:3000';  /* IP Address on Company Laptop */
const String baseUrl =
    'http://192.168.0.128:3000'; /* IP Address on Won Laptop */

// Coordinate
const String GOOGLE_MAPS_API_KEY = "AIzaSyDqSqaRpMggI2QWsPd-jdp-611FxMrxyMs";
const String YOU_ARE_HERE_ICON = 'assets/images/you_are_here.png';
const String METER_ICON = 'assets/images/meter_icon.png';
const String METER_KUANTAN = 'assets/json/kuantan_meter.json';
const String METER_KUALA_TERENGGANU_STRADA =
    'assets/json/kuala_terengganu_strada_meter.json';
const String METER_KUALA_TERENGGANU_CALE =
    'assets/json/kuala_terengganu_cale_meter.json';
const String METER_MACHANG = 'assets/json/machang_meter.json';

// Colors
const Color kBlack = Colors.black;
const Color kWhite = Colors.white;
const Color kPrimaryColor = Color.fromRGBO(34, 74, 151, 1);
const Color kSecondaryColor = Color.fromRGBO(134, 156, 255, 1);
const Color kBackgroundColor = Color.fromRGBO(244, 246, 255, 1);
const Color kGrey = Colors.grey;
const Color kOrange = Colors.orange;
const Color kYellow = Colors.yellow;
const Color kRed = Color.fromARGB(255, 240, 108, 99);

// image
const String logo = 'assets/images/Logo ccp.png';
const String backgroundSignIn = 'assets/images/login_screen.png';
const String backgroundSignUp = 'assets/images/signup_wall.png';

// Service Image
const String parkingImage = 'assets/images/ss_1.png';
const String summonImage = 'assets/images/ss_2.png';
const String reserveBayImage = 'assets/images/ss_3.png';
const String monthlyPassImage = 'assets/images/ss_4.png';
const String transportInfoImage = 'assets/images/ss_5.png';

// News Image
const String newsImage1 = 'assets/images/news_1.png';
const String newsImage2 = 'assets/images/news_2.png';
const String newsImage3 = 'assets/images/news_3.png';

const String kuantanLogo = 'assets/images/pbtlogo_kuantan-removebg-preview.png';
const String terengganuLogo = 'assets/images/pbkk_kt-removebg-preview.png';
const String machangLogo = 'assets/images/PBT_machang-removebg-preview.png';

const String pahangImg = 'assets/images/pahang_flag.png';
const String terengganuImg = 'assets/images/terengganu_flag.png';
const String kelantanImg = 'assets/images/kelantan_flag.png';

// Save Local Storage Keys
const String keyToken = 'token';
const String keyLocation = 'location';
const String keyState = 'state';
const String keyLogo = 'logo';
const String keyColor = 'color';
const String isFirstRunKey = 'isFirstRun';
const String paymentKey = 'paymentKey';

class GlobalDeclaration {
  static String globalDuration = '';
  static double globalAmount = 0.0;
}

class GlobalState {
  static String location = '';
  static String plate = '';
  static double amount = 0.0;
  static int month = 0;
}

class DialogType {
  static const int info = 1;
  static const int danger = 2;
  static const int warning = 3;
  static const int success = 4;
}

// Success
const kBgSuccess = Colors.green;
const kTextSuccess = Color.fromRGBO(236, 253, 245, 1.0);

// Danger
const kBgDanger = Color.fromRGBO(153, 27, 27, 1.0);
const kTextDanger = Color.fromRGBO(254, 242, 242, 1.0);

// Warning
const kBgWarning = Color.fromRGBO(188, 139, 20, 6);
const kTextWarning = Color.fromRGBO(255, 251, 235, 1.0);

// Info
const kBgInfo = kPrimaryColor;
const kTextInfo = Color.fromRGBO(236, 253, 245, 1.0);
