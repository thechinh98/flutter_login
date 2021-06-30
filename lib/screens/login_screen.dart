import 'package:auth/login/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/navigation/router_service.dart';
import 'package:flutter_login/navigation/routes.dart';
import 'package:game/providers/user_model.dart';
import 'package:game/route/routes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotEmpty = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Login Screen',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (text){
                  setState(() {
                    availableLogin();
                  });
                },
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                onChanged: (text){
                  setState(() {
                    availableLogin();
                  });
                },
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary:Colors.blue, textStyle: TextStyle(color: Colors.white)),
                child: Text('Login'),
                onPressed: _isNotEmpty ? () {
                  String email = nameController.text;
                  String password = passwordController.text;
                  logInSuccess(email, password);
                } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  logInSuccess(String username, String password) async{
    await Future.delayed(Duration(milliseconds: 700));
    LoginModel _loginModel =
    Provider.of<LoginModel>(context, listen: false);
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    _loginModel.loginSuccess(username, password);
    _userModel.loadUserData(username: username);
    NavigationService().pushReplacementNamed(ROUTER_HOME);
  }
  void availableLogin() {
    if (nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      _isNotEmpty = true;
    } else {
      _isNotEmpty =  false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}