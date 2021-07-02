import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/barem_score.dart';
import 'package:game/model/core/test_score.dart';

class ScoreModel extends ChangeNotifier{
  List<BaremScores> baremScore = <BaremScores> [];
  String testTitle = "";
  int? testId;
  int readingScore = 0;
  int readingCorrect = 0;
  int listeningScore = 0;
  int listeningCorrect = 0;
  List<TestScore> listTestScore = [];
  loadBaremScore() async{
    var jsonText = await rootBundle.loadString("packages/game/assets/data/baremScores.json");
    baremScore = parseBaremScore(jsonText);
    listTestScore = [];
    print("SCORE MODEL: LOAD DATA FINISH");
    notifyListeners();
  }
  getReadingScore(int correctReadingAnswer){
    baremScore.forEach((element) {
      if(element.correctQuestion == correctReadingAnswer){
        readingScore = element.readingScore;
        listTestScore.add(TestScore(scoreTitle: "Reading", point: readingScore));
        readingCorrect = correctReadingAnswer;
        notifyListeners();
      }
    });
  }
  getListeningScore(int correctListeningAnswer){
    baremScore.forEach((element) {
      if(element.correctQuestion == correctListeningAnswer){
        listeningScore = element.listeningScore;
        listTestScore.add(TestScore(scoreTitle: "Listening", point: listeningScore));
        listeningCorrect = correctListeningAnswer;
        notifyListeners();
      }
    });
  }
  getTestId(int id){
    testId = id;
    notifyListeners();
  }
  getTestName(String name){
    testTitle = name;
    notifyListeners();
  }
}