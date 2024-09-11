import 'package:get/get.dart';
import 'package:project/screens/home/card_stack.dart';
import 'package:project/screens/screens.dart';

class AppRoute {
  static const splashScreen = '/splashScreen';
  static const loginScreen = '/loginScreen';
  static const signUpScreen = '/signupScreen';
  static const homeScreen = '/homeScreen';
  static const profileScreen = '/profileScreen';
  static const transactionHistoryScreen = '/transactionHistoryScreen';
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
  static const monthlyPassScreen = '/monthlyPassScreen';
  static const monthlyPassPaymentScreen = '/monthlyPassPaymentScreen';
  static const monthlyPassReceiptScreen = '/monthlyPassReceiptScreen';
  static const transportInfoScreen = '/transportInfoScreen';
  static const notificationScreen = '/notificationScreen';

  static final routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    // GetPage(name: homeScreen, page: () => const CardsStack()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(
        name: transactionHistoryScreen,
        page: () => const TransactionHistoryScreen()),
    GetPage(name: parkingScreen, page: () => const ParkingScreen()),
    GetPage(
        name: parkingPaymentScreen, page: () => const ParkingPaymentScreen()),
    GetPage(name: parkingReceiptScreen, page: () => const ReceiptScreen()),
    GetPage(name: pbtScreen, page: () => const PbtScreen()),
    GetPage(name: stateScreen, page: () => const StateScreen()),
    GetPage(name: reloadScreen, page: () => const ReloadScreen()),
    GetPage(name: reloadPaymentScreen, page: () => const ReloadPaymentScreen()),
    GetPage(name: reloadReceiptScreen, page: () => const ReloadReceiptScreen()),
    GetPage(name: reserveBayScreen, page: () => const ReserveBayScreen()),
    GetPage(name: summonsScreen, page: () => const SummonsScreen()),
    GetPage(
        name: summonsPaymentScreen, page: () => const SummonsPaymentScreen()),
    GetPage(name: monthlyPassScreen, page: () => const MonthlyPassScreen()),
    GetPage(
        name: monthlyPassPaymentScreen,
        page: () => const MonthlyPassPaymentScreen()),
    GetPage(
        name: monthlyPassReceiptScreen,
        page: () => const MonthlyPassReceiptScreen()),
    GetPage(name: transportInfoScreen, page: () => const TransportInfoScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
  ];
}
