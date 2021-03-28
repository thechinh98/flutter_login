import 'package:flutter/material.dart';
import 'package:service/service.dart';

class LoginLogic{
  final BuildContext _context;
  final LoginService _service;

  LoginLogic(this._context, this._service);

  loadData() {
    _service.func();
  }
}