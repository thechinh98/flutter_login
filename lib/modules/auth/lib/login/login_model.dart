import 'package:flutter/material.dart';

import 'account.dart';

class LoginModel extends ChangeNotifier {

  bool isLogin;
  Account account = new Account();
  LoginModel({this.isLogin = false});

  void loginSuccess(String username, String password){
    account.username = username;
    account.password = password;
    notifyListeners();
  }

  void logOut() {
    account = new Account();
    notifyListeners();
  }
}