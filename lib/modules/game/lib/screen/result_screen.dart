import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/barem_score.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late TestGameModel gameModel;
  late List<BaremScores> baremScore;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameModel = context.read<TestGameModel>();
    getBaremScore();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  getBaremScore() async{
    var jsonText = await rootBundle.loadString("package:game/assets/data/baremScores.json");
    print(jsonText);
  }
}
