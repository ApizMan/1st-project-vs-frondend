import 'package:flutter/material.dart';
import 'package:project/constant.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:project/routes/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeStepper = 1;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    _initialize();
    super.didChangeDependencies();
  }

  void _initialize() async {
    final token = await AuthResources.getToken();
    if (!_isInit) {
      await Future.delayed(
        const Duration(milliseconds: 1500),
      );
      if (!mounted) {
        return;
      }

      if (token != null) {
        Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, AppRoute.loginScreen);
      }

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: kWhite,
        ),
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(logo),
      ),
    );
  }
}
