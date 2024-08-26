import 'package:flutter/material.dart';

class BackgroundImage_signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets_images/signup_wall.png'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
        )
      ),
    );
  }
}