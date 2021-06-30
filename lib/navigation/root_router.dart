import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/navigation/routes.dart';
import 'package:flutter_login/screens/home_screen.dart';
import 'package:flutter_login/screens/login_screen.dart';
import 'package:game/route/routes.dart';
import 'package:game/screen/result/result_screen.dart';
import 'package:game/screen/test_progress/progress_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;

  switch (settings.name) {
    case ROUTER_LOGIN:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: LoginScreen(),
      );
    case ROUTER_HOME:
      return _getPageRoute(routeName: settings.name!, viewToShow: HomeScreen());
    case ROUTER_RESULT_SCREEN:
      return _getPageRoute(routeName: settings.name!, viewToShow: ResultScreen());
    case ROUTER_PROGRESS_SCREEN:
      return _getPageRoute(routeName: settings.name!, viewToShow: ProgressScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text("No route define to ${settings.name}"),
          ),
        ),
      );
  }
}

PageRoute _getPageRoute(
    {required String routeName, required Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
