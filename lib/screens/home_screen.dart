import 'package:auth/login/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/navigation/router_service.dart';
import 'package:flutter_login/navigation/routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginModel _loginModel =
    Provider.of<LoginModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('User ID: ${_loginModel.account?.username ?? ''}'),
            Text('password: ${_loginModel.account?.password ?? ''}'),
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                logout();
              },
            )
          ],
        ),
      ),
    );
  }

  logout() {
    LoginModel _loginModel =
    Provider.of<LoginModel>(context, listen: false);
    NavigationService().pushReplacementNamed(ROUTER_LOGIN);
  }
}

