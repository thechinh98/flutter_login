import 'package:game/model/game/flash_game_object.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/matching_game_object.dart';
import 'package:game/model/game/para_game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/model/game/spelling_game_object.dart';

import 'package:flutter/material.dart';
import 'package:game/screen/game/game_view/flash_card/flash_card_view.dart';
import 'package:game/screen/game/game_view/matching/matching_view.dart';
import 'package:game/screen/game/game_view/paragraph/paragraph_view.dart';
import 'package:game/screen/game/game_view/quiz/quiz_view.dart';
import 'package:game/screen/game/game_view/spelling/spelling_view.dart';

import '../../game_screen.dart';

typedef OnAnswer<T>(AnswerType type, [T? params]);

class GameItemView extends StatelessWidget {
  final GameObject gameObject;
  final OnAnswer? onAnswer;
  final int gameType;
  final int? gameSkill;
  GameItemView(
      {Key? key,
      required this.gameObject,
      this.onAnswer,
      required this.gameType, this.gameSkill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gameObject is QuizGameObject) {
      return QuizView(
        onAnswer: onAnswer,
        gameObject: gameObject as QuizGameObject,
        gameType: gameType,
      );
    } else if (gameObject is FlashGameObject) {
      return FlashCardView(
        onAnswer: onAnswer,
        gameObject: gameObject as FlashGameObject,
      );
    } else if (gameObject is SpellingGameObject) {
      return SpellingView(
        onAnswer: onAnswer!,
        gameObject: gameObject as SpellingGameObject,
      );
    } else if (gameObject is MatchingGameObject) {
      return MatchingView(
        onAnswer: onAnswer!,
        gameObject: gameObject as MatchingGameObject,
      );
    } else if (gameObject is ParaGameObject) {
      return ParagraphView(
        gameObject: gameObject as ParaGameObject,
        gameSkill: gameSkill!,
      );
    } else {
      return Center(
        child: Text("undefined game"),
      );
    }
  }
}
