import 'package:game/model/core/choice.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/para_game_object.dart';
import 'package:game/screen/game/game_view/quiz/quiz_view.dart';
class QuizGameObject extends GameObject {
  ParaGameObject? parent;
  String? questionId;
  late List<Choice> choices;
  List<Choice> answered = [];
  int correctNum = 0;

  QuizGameObject.fromQuestion(Question questionDb) : super.fromQuestion(questionDb) {
    questionId = questionDb.id;
    choices = questionDb.choices ?? <Choice>[];
    getCorrectNum();
  }

  getCorrectNum() {
    int i = 0;
    choices.forEach((element) {
      if (element.isCorrect) i++;
      if (element.selected) answered.add(element);
    });
    correctNum = i;
  }

  onAnswer(QuizAnswerParams params) {
    switch (params.type) {
      case QuizAnswerType.choice_click:
        if (gameObjectStatus == GameObjectStatus.answered) {
          return;
        }
        Choice clicked = params.choice!;
        updateProgress(clicked);
        calculatePoint();
        break;
      case QuizAnswerType.continue_click:
        break;
      default:
        break;
    }
  }
  onTestAnswer(QuizAnswerParams params) {
    switch (params.type){
      case QuizAnswerType.choice_click:
        Choice clicked = params.choice!;
        updateProgress(clicked);
        break;
      case QuizAnswerType.continue_click:
        calculatePoint();
        break;
      default:
        break;
    }
  }

  updateProgress(Choice choice) {
    gameObjectStatus = GameObjectStatus.answered;
    if (answered.contains(choice)) {
      return;
    }
    // un-select choice when choose more than number of correct choices
    choice.selected = true;
    answered.add(choice);
    // only affect on test mode
    if (answered.isNotEmpty && answered.length > correctNum) {
      Choice oldChoice = answered[0];
      oldChoice.selected = false;
      Choice x = choices.firstWhere((element) => element.id == oldChoice.id)
        ..selected = false;answered.removeAt(0);
    }
  }

  calculatePoint(){
    if (answered.length == correctNum) {
      int selectedCorrect = 0;
      answered.forEach((element) {
        if (element.isCorrect) selectedCorrect++;
      });
      if (selectedCorrect == correctNum) {
        questionStatus = QuestionStatus.answeredCorrect;
      } else {
        questionStatus = QuestionStatus.answeredIncorrect;
      }
    }
  }

  @override
  reset() {
    super.reset();
    answered = [];
    choices.forEach((element) {
      if (element.selected) {
        element.selected = false;
      }
    });
  }
}