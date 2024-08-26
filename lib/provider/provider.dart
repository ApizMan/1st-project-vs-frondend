import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:project/component/home_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Make sure this import points to the file where your data models are defined.

// UserProfile provider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null) {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse("http://192.168.43.235:3000/auth/user-profile"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      state = UserProfile.fromJson(jsonDecode(response.body));
    }
  }
}

// Wallet provider
final walletProvider = StateNotifierProvider<WalletNotifier, Wallet?>((ref) {
  return WalletNotifier();
});

class WalletNotifier extends StateNotifier<Wallet?> {
  WalletNotifier() : super(null) {
    fetchWallet();
  }

  Future<void> fetchWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("http://192.168.43.235:3000/wallet/wallet-info"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      state = Wallet.fromJson(jsonDecode(response.body));
    }
  }
}
