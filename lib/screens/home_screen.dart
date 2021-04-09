import 'package:auth/login/login_model.dart';
import 'package:database/topic_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/navigation/router_service.dart';
import 'package:flutter_login/navigation/routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

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
    LoginModel _loginModel = Provider.of<LoginModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Xin chào, ${_loginModel.account.username ?? ''}", style: TextStyle(fontSize: 20),),
                SizedBox(height: 90,),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoundedButton(title: "PRACTICE", press: () {
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => TopicListScreen(type: 3,)));
                      }),
                      SizedBox(height: 30,),
                      RoundedButton(title: "TEST", press: () {}, color: Colors.lightGreenAccent,),
                      SizedBox(height: 60,),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  logout() {
    LoginModel _loginModel = Provider.of<LoginModel>(context, listen: false);
    _loginModel.logOut();
    NavigationService().pushReplacementNamed(ROUTER_LOGIN);
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,required this.title,required this.press,this.color = Colors.pinkAccent,
  }) : super(key: key);
  final String title;
  final GestureTapCallback press;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
