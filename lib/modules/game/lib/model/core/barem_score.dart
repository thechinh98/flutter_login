import 'dart:convert';

import 'package:game/model/database_model/score_database.dart';

class BaremScores{
  int? correctQuestion;
  int listeningScore;
  int readingScore;

  BaremScores({required this.correctQuestion,required this.listeningScore, required this.readingScore});

  factory BaremScores.fromJson(Map<String, dynamic> json){
    return BaremScores(correctQuestion: json[columnCorrect] as int, listeningScore: json[columnListeningScore] as int, readingScore: json[columnReadingScore] as int);
  }
  reset(){
    correctQuestion = 0;
    listeningScore = 0;
    readingScore = 0;
  }
}
List<BaremScores> parseBaremScore(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<BaremScores>((json) => BaremScores.fromJson(json)).toList();
}

