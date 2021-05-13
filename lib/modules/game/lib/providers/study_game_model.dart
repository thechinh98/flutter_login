import 'package:database/constant.dart';
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
import 'package:game/screen/game/game_view/quiz/quiz_view.dart';
import 'package:game/screen/game_screen.dart';
import 'package:game/service/service.dart';

class StudyGameModel extends GameModel implements GamePlay {
  StudyGameModel() {
    this.gameService = GameServiceInitializer().gameService;
  }

  loadData({required String topicId, required int subjectType}) async {
    resetListGame();
    questions.clear();
    this.currentTopic = topicId;
    List<Question> quesDb = [];

    print('CHINHLT: StudyGameModel- load data - topic ID: $topicId');

    quesDb = await gameService.loadQuestionsByParentId(
        parentId: topicId, subjectType: subjectType);

    Map<String, Question> mapQuestionHasChild = {};
    // Map<String, ParaGameObject> mapGameObjectHasChild = {};
    quesDb.forEach((element) {
      if (element.hasChild && element.skill != -400) {
        mapQuestionHasChild.putIfAbsent(element.id!, () => element);
        // mapGameObjectHasChild.putIfAbsent(element.id, () => ParaGameObject.fromQuestion(element));
      } else {
        questions.add(element);
      }
    });

    List<Question> childQuestions = [];
    if (mapQuestionHasChild.isNotEmpty) {
      childQuestions = await gameService.loadChildQuestionList(
          mapQuestionHasChild, subjectType);
      childQuestions.forEach((element) {
        if (element.choices!.isNotEmpty) {
          Question? parentQuestion = mapQuestionHasChild[element.parentId!];
          if (parentQuestion != null) {
            element.parentQues = parentQuestion;
            // element.sound = parentQuestion.sound;
          }
          questions.add(element);
        } else {
          // SPELL GAME
        }
      });
    }

    // generateGame(questions.sublist(0, 6), StudyType.practice, choicesNum: 4);
    generateGame(questions, StudyType.practice, choicesNum: 4);
    listGames!.sort((a, b) => (a.orderIndex! < b.orderIndex! ? -1 : 1));

    // notifyListeners();
    calcProgress();
    notifyListeners();
    onContinue();
  }

  generateGame(List<Question> questions, StudyType type, {int? choicesNum}) {
    if (type == StudyType.practice) {
      final iterator = questions.iterator;
      while (iterator.moveNext()) {
        final question = iterator.current;

        // TODO set game type
        final gameType = _getGameType(question);
        switch (gameType) {
          case GameType.QUIZ:
            createQuizGameObject(question, question.choices!.length);
            break;
          case GameType.FLASH_CARD:
            final flashGame = FlashGameObject.fromQuestion(question);
            listGames!.add(flashGame);
            break;
          case GameType.SPELLING:
            final spellingGame = SpellingGameObject.fromQuestion(question);
            listGames!.add(spellingGame);
            break;
          case GameType.MATCHING:
            List<Question> questionList = [];
            questionList.add(question);
            if (iterator.moveNext()) {
              questionList.add(iterator.current);
              final matchingGame =
                  MatchingGameObject.fromQuestions(questionList);
              listGames!.add(matchingGame);
            }
            break;
          case GameType.PARAGRAPH:
            final paragraphGame = ParaGameObject.fromQuestion(question);
            listGames!.add(paragraphGame);
            break;
          default:
            break;
        }
      }
    }
  }

  ParaGameObject createParagraphGameWithId(String paraGameId) {
    ParaGameObject paraGameObject = listGames!
        .firstWhere((element) => element.id == paraGameId) as ParaGameObject;
    listGames!.forEach((element) {
      if (element is QuizGameObject) {
        if(element.parent!.id == paraGameId){
          paraGameObject.children.add(element);
        }
      }
    });
    return paraGameObject;
  }

  GameType _getGameType(Question? question) {
    if (question!.skill == 0 && question.type == 0) {
      return GameType.FLASH_CARD;
    } else if (question.skill == -400 && question.type == 1) {
      return GameType.PARAGRAPH;
    }
    return GameType.QUIZ;
  }

  createQuizGameObject(Question question, int? choicesNum) {
    final quiz = QuizGameObject.fromQuestion(question);
    if (choicesNum != null) {
      final numOfFakeChoices =
          choicesNum - quiz.choices.length < questions.length - 1
              ? choicesNum - quiz.choices.length
              : questions.length - 1;
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
          final choiceToClone =
              questions[availableIndexes.removeAt(0)].choices![0];
          final fakeChoice = Choice.cloneWrongChoice(choiceToClone);
          quiz.choices.add(fakeChoice);
        }
      }
    }
    quiz.choices.shuffle();

    Map<String, ParaGameObject> mapHasChild = {};
    if (question.parentQues != null) {
      String? key = question.parentQues!.id;
      if (!mapHasChild.containsKey(key)) {
        ParaGameObject paraGameObject =
            ParaGameObject.fromQuestion(question.parentQues!);
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
        (currentGames as QuizGameObject).onAnswer(params as QuizAnswerParams);
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
      if (currentGames!.questionStatus == QuestionStatus.answeredCorrect) {
        listDone.add(currentGames!);
      } else {
        listGames!.add(currentGames!);
      }
    }
  }

  @override
  calcProgress() {
    List<GameObject> resultList = [];
    resultList.addAll(listGames!);
    resultList.addAll(listDone);
    if (currentGames != null &&
        currentGames!.gameObjectStatus == GameObjectStatus.waiting &&
        (currentGames is QuizGameObject ||
            currentGames is MatchingGameObject)) {
      resultList.add(currentGames!);
    }
    gameProgress = Progress.calcProgress(resultList);
  }

  @override
  void onContinue({Function? callBack}) {
    if (isFinished()) {
      onFinish();
      return;
    }
    if (listGames!.isEmpty) {
      return;
    }
    currentGames = listGames!.removeAt(0);
    if (currentGames!.gameObjectStatus == GameObjectStatus.answered) {
      if (currentGames!.questionStatus == QuestionStatus.answeredIncorrect) {
        currentGames!.reset();
      }
    }

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
    return listDone.isNotEmpty && listGames!.isEmpty;
  }
}
