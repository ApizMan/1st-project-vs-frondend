import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:project/component/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Adjust the import to point to your providers.dart file
// Adjust the import to point to your home screen file

void main() async {  
  runApp(const ProviderScope(child: MyApp()));
  FilePicker.platform;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,       
      home: LoginScreen(),
    );
  }
}