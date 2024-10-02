// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/constant.dart';
import 'package:project/routes/route_manager.dart';

class BackgroundImage extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  const BackgroundImage({
    super.key,
    required this.body,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      backgroundColor: kBlack,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          opacity: 0.6,
          image: AssetImage(Get.currentRoute == AppRoute.loginScreen
              ? backgroundSignIn
              : backgroundSignUp),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.black12, BlendMode.darken),
        )),
        child: body,
      ),
    );
  }
}
