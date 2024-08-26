import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets_images/login_screen.png'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
        )
      ),
    );
  }
}