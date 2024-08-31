// Base URL
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// const String baseUrl = 'http://192.168.0.128:3000';  /* IP Address on Company Laptop */
const String baseUrl =
    'http://192.168.100.113:3000'; /* IP Address on Won Laptop */

// Colors
const Color kBlack = Colors.black;
const Color kWhite = Colors.white;
const Color kPrimaryColor = Color.fromRGBO(34, 74, 151, 1);
const Color kSecondaryColor = Color.fromRGBO(134, 156, 255, 1);
const Color kBackgroundColor = Color.fromRGBO(244, 246, 255, 1);
const Color kGrey = Colors.grey;

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

// Save Local Storage Keys
const String keyToken = 'token';
class GlobalDeclaration {
  static String globalDuration = '';
  static double globalAmount = 0.0;
}
