import 'package:game/components/new_sound_data.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/game/flash_game_object.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/providers/audio_model.dart';

import 'package:flutter/material.dart';
import 'package:game/providers/game_model.dart';
import 'package:game/providers/study_game_model.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:game/route/routes.dart';
import 'package:game/screen/game/game_view/game_item_view.dart';
import 'package:game/screen/game/game_view/quiz/quiz_view.dart';
import 'package:game/screen/screen_logic.dart';
import 'package:game/screen/study/study_logic.dart';
import 'package:game/screen/study/study_progress.dart';
import 'package:game/screen/test/test_logic.dart';
import 'package:game/utils/constant.dart';
import 'package:provider/provider.dart';

enum AnswerType { quiz, spelling, matching, flash }
enum StudyType { study, practice }

class GameScreen extends StatefulWidget {
  final String topicId;
  final int gameType;
  GameScreen({required this.topicId, required this.gameType});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  String get topicId => widget.topicId;
  int get gameType => widget.gameType;

  late ScreenLogic screenLogic;
  late GameModel gameModel;
  bool isSoundDataLoaded = false;
  late AudioModel audioModel;
  //animation
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    if (gameType == GAME_STUDY_MODE) {
      print("CHINHLT: GAME_SCREEN: Init state STUDY MODE");
      screenLogic = StudyLogic(context: context, topicId: topicId);
      gameModel = context.read<StudyGameModel>();
    } else if (gameType == GAME_TEST_MODE) {
      print("CHINHLT: GAME_SCREEN: Init state TEST MODE");
      screenLogic = TestLogic(context: context, topicId: topicId);
      gameModel = context.read<TestGameModel>();
    }

    gameModel.addListener(listener);

    screenLogic.loadData();

    //init animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _animation2 = Tween<Offset>(begin: Offset.zero, end: Offset(-1.0, 0.0))
        .animate(_controller);
    super.initState();
  }

  int firstRun = 0;
  listener() async {
    audioModel = context.read<AudioModel>();
    if (gameModel.listGames!.isNotEmpty) {
      if (audioModel.sounds.isEmpty && firstRun == 0) {
        firstRun++;
        List<NewSoundData> _sounds = [];
        gameModel.listGames!.forEach((element) {
          _sounds.add(NewSoundData.fromGameObject(
              questionId: element.id, sound: element.question.sound));

          if (element is QuizGameObject && element.parent != null) {
            _sounds.add(NewSoundData.fromGameObject(
                questionId: element.parent!.id,
                sound: element.parent!.question.sound));
          }
        });
        await audioModel.loadData(_sounds);
        setState(() {
          isSoundDataLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
        actions: [
          gameType == GAME_TEST_MODE
              ? FlatButton(
                  onPressed: () {
                    (gameModel as TestGameModel).onFinish();
                    audioModel.reset();
                    Navigator.popAndPushNamed(context, ROUTER_RESULT_SCREEN);
                  },
                  child: Text("Submit"),
                  textColor: Colors.white,
                )
              : Container()
        ],
      ),
      body: SafeArea(
        child: gameType == GAME_TEST_MODE
            ? Consumer(
                builder: (_, TestGameModel gameModel, __) {
                  if (gameModel.isFinishGame) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Finished!'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Continue'),
                            onPressed: () {
                              screenLogic.navigateAfterFinishingStudy();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  GameObject? previousGame = gameModel.previousGame;
                  gameModel.previousGame = gameModel.currentGames;

                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: _renderCurrentGame(
                          gameModel.currentGames,
                          previousGame,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _buttonPress(),
                        child: Text("Show Question"),
                      ),
                      _renderContinueBtn(),
                    ],
                  );
                },
              )
            : Consumer(
                builder: (_, StudyGameModel gameModel, __) {
                  if (gameModel.isFinishGame) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Finished!'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            child: Text('Continue'),
                            onPressed: () {
                              screenLogic.navigateAfterFinishingStudy();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  GameObject? previousGame = gameModel.previousGame;
                  gameModel.previousGame = gameModel.currentGames;

                  return Column(
                    children: <Widget>[
                      _buildStudyProgress(),
                      Expanded(
                        child: _renderCurrentGame(
                          gameModel.currentGames,
                          previousGame,
                        ),
                      ),
                      if (gameModel.currentGames is! FlashGameObject)
                        _renderContinueBtn(),
                    ],
                  );
                },
              ),
      ),
    );
  }

  _buildStudyProgress() {
    var progress = context.read<StudyGameModel>().gameProgress;
    if (progress.total == 0) return SizedBox();
    return StudyProgressWidget(
      correct: progress.correct,
      total: progress.total,
    );
  }

  Widget _renderCurrentGame(
    GameObject? _current,
    GameObject? _pre,
  ) {
    if (_current == null) {
      return Container();
    }
    return GameItemView(
      gameObject: _current,
      onAnswer: screenLogic.onAnswer,
      gameType: gameType,
    );
  }

  void startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  Container _renderContinueBtn() {
    GameModel? currentGameModel;
    if (gameType == GAME_STUDY_MODE) {
      currentGameModel = context.read<StudyGameModel>();
    } else if (gameType == GAME_TEST_MODE) {
      currentGameModel = context.read<TestGameModel>();
    }
    if (currentGameModel!.currentGames == null)
      return Container(
        child: null,
      );
    Color _color = Theme.of(context).backgroundColor;
    if (currentGameModel.currentGames!.gameObjectStatus ==
        GameObjectStatus.waiting) {
      return Container(child: null);
    }
    // Check if finish or not
    return Container(
      child: MaterialButton(
        onPressed: () {
          QuizAnswerParams params = QuizAnswerParams(type: QuizAnswerType.continue_click,);
          if(screenLogic.onAnswer != null){
            screenLogic.onAnswer(AnswerType.quiz, params);
          }
          screenLogic.onContinue();
        },
        clipBehavior: Clip.antiAlias,
        animationDuration: Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _color,
            border: Border.all(
              color: _color,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              (currentGameModel.currentGames!.questionStatus ==
                          QuestionStatus.answeredCorrect &&
                      currentGameModel.listGames!.isEmpty)
                  ? 'Finish'
                  : 'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _buttonPress() {
    TestGameModel tempGameModel = context.read<TestGameModel>();
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return GridView.count(
            crossAxisCount: 5,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 8.0,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: List.generate(
                tempGameModel.questions.length,
                (index) => questionIndexItem(
                    index: index, testGameModel: tempGameModel)),
          );
        });
  }

  questionIndexItem(
      {required int index, required TestGameModel testGameModel}) {
    return GestureDetector(
      onTap: () {
        testGameModel.chooseGame(index);
        Navigator.pop(context);
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: _getQuestionColor(testGameModel, index),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "${index + 1}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color _getQuestionColor(TestGameModel testGameModel, int index) {
    if (testGameModel.indexQuestion == index) {
      return Colors.yellow;
    }
    if (testGameModel.listGames![index].gameObjectStatus ==
        GameObjectStatus.answered) {
      return Colors.green;
    }
    return Colors.grey;
  }

  @override
  void dispose() {
    gameModel.removeListener(listener);
    gameModel.resetListGame();
    audioModel.reset();
    super.dispose();
  }
}
