import 'package:auth/login/login_model.dart';
import 'package:database/database_service.dart';
import 'package:database/firebase_data_service_impl.dart';
import 'package:game/providers/audio_model.dart';
import 'package:game/providers/study_game_model.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:game/service/game_service_impl.dart';
import 'package:game/service/service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:service/login/login_service_impl.dart';
import 'package:service/service.dart';
import 'package:database/topic_model.dart';
import 'package:sqflite/sqflite.dart';

class AppProvider {
  factory AppProvider() {
    if(_this == null){
      _this = AppProvider._getInstance();
    }
    return _this!;
  }
  static AppProvider? _this;
  AppProvider._getInstance();

  late LoginModel loginModel;
  late TopicModel topicModel;
  late StudyGameModel studyGameModel;
  late AudioModel audioModel;
  late TestGameModel testGameModel;

  late DatabaseService _dbService;
  late LoginService _loginService;

  Future initApp() async {
    topicModel = TopicModel();
    loginModel = LoginModel();
    audioModel = AudioModel();

    final gameService = GameServiceImpl();
    GameServiceInitializer().init(gameService);
    studyGameModel = StudyGameModel();
    testGameModel = TestGameModel();

    _dbService = FirebaseServiceImpl();
    _loginService = LoginServiceImpl(dbService);


  }

  List<SingleChildWidget> get provides => [
    ChangeNotifierProvider(create: (_) => loginModel),
    ChangeNotifierProvider(create: (_) => topicModel),
    ChangeNotifierProvider(create: (_) => audioModel),
    ChangeNotifierProvider(create: (_) => studyGameModel),
    ChangeNotifierProvider(create: (_) => testGameModel),
  ];
  LoginService get loginService => _loginService;
  DatabaseService get dbService => _dbService;

}