import 'package:get/get.dart';
import 'package:project/screens/screens.dart';

class AppRoute {
  static const splashScreen = '/splashScreen';
  static const loginScreen = '/loginScreen';
  static const signupScreen = '/signupScreen';
  static const homeScreen = '/homeScreen';
  static const parkingScreen = '/parkingScreen';
  static const parkingPaymentScreen = '/parkingPaymentScreen';
  static const parkingReceiptScreen = '/parkingReceiptScreen';

  static final routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signupScreen, page: () => const SignUpScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: parkingScreen, page: () => const ParkingScreen()),
    GetPage(name: parkingPaymentScreen, page: () => const PaymentScreen()),
    GetPage(name: parkingReceiptScreen, page: () => const ReceiptScreen()),
  ];
}
