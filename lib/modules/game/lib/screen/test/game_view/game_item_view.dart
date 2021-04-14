import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:flutter/material.dart';
import 'package:game/screen/test/game_view/quiz/quiz_view.dart';
import 'package:game/screen/test/test_screen.dart';


typedef OnAnswer<T>(AnswerType type, [T? params]);

class GameItemView extends StatelessWidget {
  final GameObject gameObject;
  final OnAnswer? onAnswer;

  GameItemView({Key? key, required this.gameObject, this.onAnswer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gameObject is QuizGameObject) {
      return QuizView(
        onAnswer: onAnswer,
        gameObject: gameObject as QuizGameObject,
      );
    } else {
      return Center(
        child: Text("undefined game"),
      );
    }
  }
}
