// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class BackgroundImage_signup extends StatelessWidget {
  const BackgroundImage_signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/signup_wall.png'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
      )),
    );
  }
}
