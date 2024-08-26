import 'package:flutter/material.dart';
import 'User.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void login(String numberPlate, String name){
    _user = User(numberPlate, name : name);
    notifyListeners();
  }

  void logout(){
    _user = null;
    notifyListeners();
  }

}