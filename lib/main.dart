import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CityCarPark());
  FilePicker.platform;
}
