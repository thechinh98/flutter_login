import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/barem_score.dart';
import 'package:game/model/core/done_test.dart';
import 'package:game/providers/score_model.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:game/providers/user_model.dart';
import 'package:game/screen/result/result_logic.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}
//
class _ResultScreenState extends State<ResultScreen> {
  late ResultLogic screenLogic;

  @override
  void initState() {
    screenLogic = ResultLogic(context: context);
    screenLogic.loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Consumer2<ScoreModel, UserModel>(
          builder: (_,scoreModel, userModel, __){
            var point = scoreModel.readingScore + scoreModel.listeningScore;
            String topicTitle = scoreModel.testTitle;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("TEST TITLE: ${scoreModel.testTitle}"),
                  Text("CORRECT READING ANSWER: ${scoreModel.readingCorrect}"),
                  Text("CORRECT LISTENING ANSWER: ${scoreModel.listeningCorrect}"),
                  Text("Total Point: $point"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Continue'),
                    onPressed: () {
                      // screenLogic.navigateAfterFinishingStudy();
                      Navigator.pop(context);
                      userModel.addTestDone(DoneTest(point: point, id: scoreModel.testId!, title: topicTitle));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }



}
