import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/barem_score.dart';
import 'package:game/providers/score_model.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:provider/provider.dart';


class ResultLogic {
  late ScoreModel scoreModel;
  late TestGameModel testGameModel;
  BuildContext context;
  ResultLogic({required this.context}){
    scoreModel = context.read<ScoreModel>();
    testGameModel = context.read<TestGameModel>();
  }
  loadData() async {
    await scoreModel.loadBaremScore();
    getListeningScore();
    getReadingScore();
  }
  getListeningScore(){
    scoreModel.getListeningScore(testGameModel.correctListeningAnswer);
  }
  getReadingScore(){
    scoreModel.getReadingScore(testGameModel.correctReadingAnswer);
  }
}