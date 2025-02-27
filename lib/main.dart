import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/app/app.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/resources/resources.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if it's the first time the app is launched
  final isFirstRun = await SharedPreferencesHelper.getDefaultSetting();

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
