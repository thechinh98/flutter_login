import 'package:flutter/material.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:game/screen/test/test_screen.dart';
import 'package:game/service/game_service.dart';
import 'package:game/service/service.dart';
import 'package:provider/provider.dart';

class TestLogic {
  final String topicId;
  late TestGameModel testGameModel;
  late GameService gameService;
  BuildContext context;

  TestLogic({required this.context, required this.topicId}) {
    testGameModel = context.read<TestGameModel>();
    gameService = GameServiceInitializer().gameService;
  }

  loadData() async {
    await testGameModel.loadData(topicId: topicId);
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