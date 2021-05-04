import 'package:game/screen/game_screen.dart';

abstract class ScreenLogic {
  Future<void> loadData();
  void onContinue();
  void navigateAfterFinishingStudy();
  Future onAnswer<T>(AnswerType type, [T? params]);
}