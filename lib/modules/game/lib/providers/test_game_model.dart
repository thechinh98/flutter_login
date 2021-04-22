import 'package:game/model/core/choice.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/game/flash_game_object.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/matching_game_object.dart';
import 'package:game/model/game/para_game_object.dart';
import 'package:game/model/game/progress.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/model/game/spelling_game_object.dart';
import 'package:game/providers/game_model.dart';
import 'package:game/screen/test/game_view/quiz/quiz_view.dart';
import 'package:game/screen/test/test_screen.dart';
import 'package:game/service/service.dart';

class TestGameModel extends GameModel implements GamePlay {
  List<Question> questions = [];
  String currentTopic = '';
  GameObject? previousGame;
  List<GameObject> listDone = [];
  int indexQuestion = 0;
  TestGameModel() {
    this.gameService = GameServiceInitializer().gameService;
  }

  loadData({required String topicId}) async {
    resetListGame();
    questions.clear();
    this.currentTopic = topicId;
    List<Question> questionsDb = [];
    print("CHINHLT: TestGameModel - load data - topic ID: $topicId");
    questionsDb = await gameService.loadTestQuestionsByParentId(parentId: topicId);
    print(
        "CHINHLT: TestGameMobel - load data - topic ID: ${questionsDb.length}");
    Map<String, Question> mapQuestionHasChild = {};
    questionsDb.forEach((element) {
      if (element.hasChild) {
        mapQuestionHasChild.putIfAbsent(element.id!, () => element);
      } else {
        questions.add(element);
      }
    });
    List<Question> childQuestions = [];
    if(mapQuestionHasChild.isNotEmpty){
      childQuestions = await gameService.loadChildQuestionList(mapQuestionHasChild);
      childQuestions.forEach((element) {
        if(element.choices!.isNotEmpty){
          Question? parentQuestion = mapQuestionHasChild[element.parentId!];
          if(parentQuestion != null){
            element.parentQues = parentQuestion;
            element.sound = parentQuestion.sound;
          }
          questions.add(element);
        } else {

        }
      });
    }
    generateGame(questions, choicesNum: 4);
    listGames!.sort((a, b) => (a.orderIndex! < b.orderIndex! ? -1 : 1));

    // notifyListeners();
    print('CHINHLT: StudyGameModel- load data - listGame size: ${listGames!.length}');
    calcProgress();
    notifyListeners();
    onContinue();
  }
  generateGame(List<Question> questions, {int? choicesNum}) {
    final iterator = questions.iterator;
      while (iterator.moveNext()) {
        final question = iterator.current;

        // TODO set game type
        final gameType = _getGameType();
        switch (gameType) {
          case GameType.QUIZ:
            createQuizGameObject(question, choicesNum);
            break;
          default:
            break;
        }
      }
  }

  GameType _getGameType() {
    return GameType.QUIZ;
  }

  createQuizGameObject(Question question, int? choicesNum) {
    final quiz = QuizGameObject.fromQuestion(question);
    if (choicesNum != null) {
      final numOfFakeChoices = choicesNum - quiz.choices.length < questions.length - 1 ? choicesNum - quiz.choices.length : questions.length - 1;
      if (numOfFakeChoices > 0) {
        int index = questions.indexOf(question);
        List<int> availableIndexes = [];
        for (int i = 0; i < questions.length; i++) {
          if (i != index) {
            availableIndexes.add(i);
          }
        }
        availableIndexes.shuffle();
        for (int j = 0; j < numOfFakeChoices; j++) {
          final choiceToClone = questions[availableIndexes.removeAt(0)].choices![0];
          final fakeChoice = Choice.cloneWrongChoice(choiceToClone);
          quiz.choices.add(fakeChoice);
        }
      }
    }

    Map<String, ParaGameObject> mapHasChild = {};
    if (question.parentQues != null) {
      String? key = question.parentQues!.id;
      if (!mapHasChild.containsKey(key)) {
        ParaGameObject paraGameObject = ParaGameObject.fromQuestion(question.parentQues!);
        quiz.parent = paraGameObject;
        mapHasChild.putIfAbsent(key!, () => paraGameObject);
      } else {
        quiz.parent = mapHasChild[key!];
      }
    }

    listGames!.add(quiz);
  }

  onAnswer<T>(AnswerType type, T params) async {
    switch (type) {
      case AnswerType.quiz:
        (currentGames as QuizGameObject).onTestAnswer(params as TestQuizAnswerParams);
        break;
      default:
        break;
    }
    updateGameProgress();
    calcProgress();
    if (currentGames is FlashGameObject) {
      onContinue();
    } else {
      notifyListeners();
    }
  }

  updateGameProgress<T>([T? params]) {
    if (currentGames!.gameObjectStatus == GameObjectStatus.answered) {
        listDone.add(currentGames!);
      } else {
      listGames!.add(currentGames!);
    }
  }

  chooseGame(int index){
    currentGames = listGames![index];
    indexQuestion = index;
    notifyListeners();
  }

  @override
  calcProgress() {
    List<GameObject> resultList = [];
    resultList.addAll(listGames!);
    resultList.addAll(listDone);
    if (currentGames != null &&
        currentGames!.gameObjectStatus == GameObjectStatus.waiting &&
        (currentGames is QuizGameObject || currentGames is MatchingGameObject)) {
      resultList.add(currentGames!);
    }
    gameProgress = Progress.calcProgress(resultList);
  }

  @override
  void onContinue({Function? callBack}) {
    indexQuestion++;
    if (isFinished()) {
      onFinish();
      return;
    }
    if (listGames!.isEmpty) {
      return;
    }
    // currentGames = listGames!.removeAt(0);
    // if (currentGames!.gameObjectStatus== GameObjectStatus.answered) {
    //   if (currentGames!.questionStatus == QuestionStatus.answeredIncorrect) {
    //     currentGames!.reset();
    //   }
    // }
    currentGames = listGames![indexQuestion];
    if (callBack != null) {
      callBack();
    }
    notifyListeners();
  }

  @override
  void onFinish() {
    isFinishGame = true;
    notifyListeners();
  }

  bool isFinished() {
    return listDone.isNotEmpty && listGames!.length == listDone.length;
  }

}
