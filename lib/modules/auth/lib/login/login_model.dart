import 'package:flutter/material.dart';

import 'account.dart';

class LoginModel extends ChangeNotifier {

  bool isLogin;
  Account account = new Account();
  LoginModel({this.isLogin = false});

  void loginSuccess(String username, String password) async {
    await Future.delayed(Duration(milliseconds: 500));
    account.username = username;
    account.password = password;
    notifyListeners();
  }
}