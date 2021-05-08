import 'package:auth/login/login_model.dart';
import 'package:database/constant.dart';
import 'package:database/topic_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/navigation/router_service.dart';
import 'package:flutter_login/navigation/routes.dart';
import 'package:game/screen/game_screen.dart';
import 'package:game/utils/constant.dart';
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
    String testTopicId = "5757482593943552";
    LoginModel _loginModel = Provider.of<LoginModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Xin chào, ${_loginModel.account.username ?? ''}", style: TextStyle(fontSize: 20),),
                SizedBox(height: 90,),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   child: Image.network("kstoeic/images/9907982_1564544773555.png",fit: BoxFit.fitWidth,),
                // ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoundedButton(title: "PRACTICE", press: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => GameScreen(topicId: testTopicId, gameType: GAME_STUDY_MODE, subjectType: toeicSubject,)));
                      }),
                      SizedBox(height: 30,),
                      RoundedButton(title: "TEST", press: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => TopicListScreen(title: "TOIEC Test", subjectType: toeicSubject, type: 3, parentId: "",)));
                      }, color: Colors.lightGreenAccent,),
                      SizedBox(height: 30,),
                      RoundedButton(title: "IELTS", press: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => TopicListScreen(title: "IELTS",subjectType: ieltsSubject, type: 1,parentId: "",)));
                      }, color: Colors.red,),
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
