import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/barem_score.dart';

class ScoreModel extends ChangeNotifier{
  List<BaremScores> baremScore = <BaremScores> [];
  String testTitle = "";
  int? testId;
  int readingScore = 0;
  int readingCorrect = 0;
  int listeningScore = 0;
  int listeningCorrect = 0;
  loadBaremScore() async{
    var jsonText = await rootBundle.loadString("packages/game/assets/data/baremScores.json");
    baremScore = parseBaremScore(jsonText);
    print("SCORE MODEL: LOAD DATA FINISH");
    notifyListeners();
  }
  getReadingScore(int correctReadingAnswer){
    baremScore.forEach((element) {
      if(element.correctQuestion == correctReadingAnswer){
        readingScore = element.readingScore;
        readingCorrect = correctReadingAnswer;
        notifyListeners();
      }
    });
  }
  getListeningScore(int correctListeningAnswer){
    baremScore.forEach((element) {
      if(element.correctQuestion == correctListeningAnswer){
        listeningScore = element.listeningScore;
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