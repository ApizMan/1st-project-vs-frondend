import 'package:get/get.dart';
import 'package:project/component/home_screen.dart';
import 'package:project/screens/screens.dart';

class AppRoute {
  static const splashScreen = '/splashScreen';
  static const loginScreen = '/loginScreen';
  static const signupScreen = '/signupScreen';
  static const homeScreen = '/homeScreen';

  static final routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signupScreen, page: () => const SignUpScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
  ];
}
