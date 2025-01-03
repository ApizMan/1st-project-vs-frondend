// Base URL
// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';

// const String baseUrl =
//     'http://192.168.0.128:3000'; /* IP Address on Company Laptop */
// const String baseUrl =
//     'http://192.168.0.100:3000'; /* IP Address on Won Laptop */

// const String baseUrl =
//     'http://60.54.235.142:3000'; /* IP Address on Oneplus -> Win Laptop */

const String baseUrl = 'http://220.158.208.216:3000'; /* IP Address Server */
const String pegeypayQRurl =
    'https://pegepay.com/api/npd-wa/order-create/custom-validity';

// Countdown
Duration countDownDuration = const Duration();

Duration parseDuration(String durationString) {
  final parts = durationString.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final seconds = int.parse(parts[2]);
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$hours:$minutes:$seconds';
}

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
const String logo = 'assets/images/logo_ccp.png';
const String backgroundSignIn = 'assets/images/login_screen.png';
const String backgroundSignUp = 'assets/images/signup_wall.png';

// Service Image
const String parkingImage = 'assets/images/ss_1.png';
const String summonImage = 'assets/images/ss_2.png';
const String reserveBayImage = 'assets/images/ss_3.png';
const String monthlyPassImage = 'assets/images/ss_4.png';
const String transportInfoImage = 'assets/images/ss_5.png';

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
const String paymentStatusKey = 'paymentStatusKey';
const String durationKey = 'durationKey';
const String expiredKey = 'expiredKey';
const String isUpdateKey = 'isUpdateKey';
const String isStartKey = 'isStartKey';
const String amountReloadKey = 'amountReloadKey';
const String carPlateKey = 'carPlateKey';
const String monthlyDurationKey = 'monthlyDurationKey';
const String orderNoKey = 'orderNoKey';
const String orderAmountKey = 'orderAmountKey';
const String orderStatusKey = 'orderStatusKey';
const String orderStoreIdKey = 'orderStoreIdKey';
const String orderShiftIdKey = 'orderShiftIdKey';
const String orderTerminalIdKey = 'orderTerminalIdKey';
const String toWhatsappNoKey = 'toWhatsappNoKey';
const String keyLanguage = 'language';
const String emailResetPasswordKey = 'emailResetPasswordKey';
const String keyNoReceipt = 'keyNoReceipt';
const String keyStartTime = 'keyStartTime';
const String keyEndTime = 'keyEndTime';
const String keyPlateNumber = 'keyPlateNumber';
const String keyDuration = 'keyDuration';
const String keyReceiptLocation = 'keyReceiptLocation';
const String keyType = 'keyType';
const String keyPegeypayToken = 'keyPegeypayToken';

class GlobalDeclaration {
  static String globalDuration = '';
  static double globalAmount = 0.0;
}

class GlobalState {
  static String location = '';
  static String plate = '';
  static double amount = 0.0;
  static int month = 0;
  static String paymentMethod = '';
}

class DialogType {
  static const int info = 1;
  static const int danger = 2;
  static const int warning = 3;
  static const int success = 4;
}

String generateReceiptNumber() {
  final random = Random();
  final receiptNumber = 100000 +
      random.nextInt(900000); // Generates a number between 100000 and 999999
  return "P$receiptNumber";
}

String generateMonthlyPassReceiptNumber() {
  final random = Random();
  final receiptNumber = 100000 +
      random.nextInt(900000); // Generates a number between 100000 and 999999
  return "MP$receiptNumber";
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
