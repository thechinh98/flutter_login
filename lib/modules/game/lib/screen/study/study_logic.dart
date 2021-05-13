import 'package:flutter/material.dart';
import 'package:game/providers/study_game_model.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:game/screen/screen_logic.dart';
import 'package:game/screen/game_screen.dart';
import 'package:game/service/game_service.dart';
import 'package:game/service/service.dart';
import 'package:provider/provider.dart';

class StudyLogic implements ScreenLogic{
  final String topicId;
  late StudyGameModel studyGameModel;
  late GameService gameService;
  late int subjectType;
  BuildContext context;

  StudyLogic({required this.context, required this.topicId, required this.subjectType}) {
    studyGameModel = context.read<StudyGameModel>();
    gameService = GameServiceInitializer().gameService;
  }

  loadData() async {
    await studyGameModel.loadData(topicId: topicId, subjectType: subjectType);
  }

  Future onAnswer<T>(AnswerType type, [T? params]) async {
    await studyGameModel.onAnswer(type, params);
  }

  onContinue() {
    studyGameModel.onContinue();
  }

  navigateAfterFinishingStudy() {
    gameService.navigateAfterFinishingStudy();
  }

}