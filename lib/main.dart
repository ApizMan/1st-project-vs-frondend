import 'package:flutter/material.dart';
import 'package:project/app/app.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/constant.dart';
import 'package:project/resources/resources.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if it's the first time the app is launched
  final isFirstRun = await SharedPreferencesHelper.getDefaultSetting();

// Get Duration if the apps been killed.
  final String duration = await SharedPreferencesHelper.getParkingDuration();
  countDownDuration = parseDuration(duration);

  final defaultLanguage = await LanguageResources.getLanguage();

  if (isFirstRun) {
    // Run the location detail saving function for the first time\
    await SharedPreferencesHelper.saveLocationDetail();

    // Set the flag to false after initialization is done
    await SharedPreferencesHelper.setDefaultSetting(false);
  }

  runApp(CityCarPark(
    defaultLanguage: defaultLanguage,
  ));
}
