// Base URL
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// const String baseUrl = 'http://192.168.0.128:3000';  /* IP Address on Company Laptop */
const String baseUrl =
    'http://192.168.0.128:3000'; /* IP Address on Won Laptop */

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
const String logo = 'assets_images/Logo ccp.png';
const String backgroundSignIn = 'assets_images/login_screen.png';
const String backgroundSignUp = 'assets_images/signup_wall.png';

// Service Image
const String parkingImage = 'assets_images/ss_1.png';
const String summonImage = 'assets_images/ss_2.png';
const String reserveBayImage = 'assets_images/ss_3.png';
const String monthlyPassImage = 'assets_images/ss_4.png';
const String transportInfoImage = 'assets_images/ss_5.png';

// News Image
const String newsImage1 = 'assets_images/news_1.png';
const String newsImage2 = 'assets_images/news_2.png';
const String newsImage3 = 'assets_images/news_3.png';

const String kuantanLogo = 'assets_images/pbtlogo_kuantan-removebg-preview.png';
const String terengganuLogo = 'assets_images/pbkk_kt-removebg-preview.png';
const String machangLogo = 'assets_images/PBT_machang-removebg-preview.png';

const String pahangImg = 'assets_images/pahang_flag.png';
const String terengganuImg = 'assets_images/terengganu_flag.png';
const String kelantanImg = 'assets_images/kelantan_flag.png';

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
