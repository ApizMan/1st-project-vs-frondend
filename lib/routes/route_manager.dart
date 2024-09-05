import 'package:get/get.dart';
import 'package:project/screens/screens.dart';
import 'package:project/screens/summons/components/summons_receipt_screen.dart';

class AppRoute {
  static const splashScreen = '/splashScreen';
  static const loginScreen = '/loginScreen';
  static const signupScreen = '/signupScreen';
  static const homeScreen = '/homeScreen';
  static const profileScreen = '/profileScreen';
  static const parkingScreen = '/parkingScreen';
  static const parkingPaymentScreen = '/parkingPaymentScreen';
  static const parkingReceiptScreen = '/parkingReceiptScreen';
  static const pbtScreen = '/pbtScreen';
  static const stateScreen = '/stateScreen';
  static const reloadScreen = '/reloadScreen';
  static const reloadPaymentScreen = '/reloadPaymentScreen';
  static const reloadReceiptScreen = '/reloadReceiptScreen';
  static const reserveBayScreen = '/reserveBayScreen';
  static const summonsScreen = '/summonsScreen';
  static const summonsPaymentScreen = '/summonsPaymentScreen';
  static const summonsReceiptScreen = '/summonsReceiptScreen';

  static final routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signupScreen, page: () => const SignUpScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: parkingScreen, page: () => const ParkingScreen()),
    GetPage(name: parkingPaymentScreen, page: () => const PaymentScreen()),
    GetPage(name: parkingReceiptScreen, page: () => const ReceiptScreen()),
    GetPage(name: pbtScreen, page: () => const PbtScreen()),
    GetPage(name: stateScreen, page: () => const StateScreen()),
    GetPage(name: reloadScreen, page: () => const ReloadScreen()),
    GetPage(name: reloadPaymentScreen, page: () => const ReloadPaymentScreen()),
    GetPage(name: reloadReceiptScreen, page: () => const ReloadReceiptScreen()),
    GetPage(name: reserveBayScreen, page: () => const ReserveBayScreen()),
    GetPage(name: summonsScreen, page: () => const SummonsScreen()),
    GetPage(name: summonsPaymentScreen, page: () => const SummonsPaymentScreen()),
    GetPage(name: summonsReceiptScreen, page: () => const SummonsReceiptScreen()),
  ];
}
