

import 'package:game/model/core/face.dart';
import 'package:game/model/core/question.dart';

import 'game_object.dart';

class FlashCardGameObject extends GameObject{
  late Face answer;
  FlashCardGameObject.fromQuestion(Question questionDb) : super.fromQuestion(questionDb){
    // init answer and get data for answer.content
    answer = Face()..content = questionDb.choices!.first.content;
  }

  onAnswer(){
    if(gameObjectStatus == GameObjectStatus.answered){
      return;
    } else {
      gameObjectStatus = GameObjectStatus.answered;
      questionStatus = QuestionStatus.answeredCorrect;
    }
  }
  
}