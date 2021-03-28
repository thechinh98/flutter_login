import 'package:auth/login/login_model.dart';
import 'package:database/database.dart';
import 'package:database/firebase_data_service_impl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:service/service.dart';
import 'package:service/login_service_impl.dart';

class AppProvider {
  factory AppProvider() {
    if(_this == null){
      _this = AppProvider._getInstance();
    }
    return _this;
  }
  static AppProvider _this;
  AppProvider._getInstance();
  DatabaseService dbService;
  LoginModel loginModel;
  LoginService _loginService;

  Future initApp() async {
    loginModel = LoginModel();
    dbService = FirebaseServiceImpl();
    _loginService = LoginServiceImpl(dbService);
  }

  List<SingleChildWidget> get provides => [
    ChangeNotifierProvider(create: (_) => loginModel),
  ];
  LoginService get loginService => _loginService;
}