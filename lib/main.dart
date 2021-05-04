import 'package:database/sql_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/navigation/root_router.dart';
import 'package:flutter_login/navigation/router_service.dart';
import 'package:flutter_login/providers/app_provider.dart';
import 'package:flutter_login/screens/home_screen.dart';
import 'package:game/repository/sql_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  SQLiteRepository sqLiteRepository = new SQLiteRepository();
  await sqLiteRepository.initDb();
  await SqfliteRepository().initDb();
  await AppProvider().initApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final NavigationService navigationService = new NavigationService();
  static final navigationKey = new GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    String appName = "App";
    return MultiProvider(
      providers: AppProvider().provides,
      child: MaterialApp(
        onGenerateTitle:(BuildContext context) => appName,
        title: appName,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigationService.navigationKey,
        onGenerateRoute: generateRoute,
        home: HomeScreen(),
      ),
    );
  }
}
