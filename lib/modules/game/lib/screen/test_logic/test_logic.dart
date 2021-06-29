import 'package:flutter/material.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:game/screen/screen_logic.dart';
import 'package:game/screen/game_screen.dart';
import 'package:game/service/game_service.dart';
import 'package:game/service/service.dart';
import 'package:provider/provider.dart';

class TestLogic implements ScreenLogic{
  final String topicId;
  final int subjectType;
  late TestGameModel testGameModel;
  late GameService gameService;
  BuildContext context;

  TestLogic({required this.context, required this.topicId,required this.subjectType}) {
    testGameModel = context.read<TestGameModel>();
    gameService = GameServiceInitializer().gameService;
  }

  loadData() async {
    await testGameModel.loadData(topicId: topicId,subjectType: subjectType);
  }

  Future onAnswer<T>(AnswerType type, [T? params]) async {
    await testGameModel.onAnswer(type, params);
  }

  onContinue() {
    testGameModel.onContinue();
  }

  navigateAfterFinishingStudy() {
    gameService.navigateAfterFinishingStudy();
  }
}