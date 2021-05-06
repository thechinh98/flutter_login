import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/barem_score.dart';
import 'package:game/providers/score_model.dart';
import 'package:game/providers/test_game_model.dart';
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
        child: Consumer(
          builder: (_, ScoreModel scoreModel, __){
            return Center(
              child: Column(
                children: [
                  Text("CORRECT READING ANSWER: ${scoreModel.readingCorrect}"),
                  Text("CORRECT LISTENING ANSWER: ${scoreModel.listeningCorrect}"),
                  Text("Total Point: ${scoreModel.readingScore + scoreModel.listeningScore}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }



}
