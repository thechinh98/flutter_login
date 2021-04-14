import 'package:flutter/material.dart';
import 'package:game/components/new_sound_data.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/providers/audio_model.dart';
import 'package:game/providers/test_game_model.dart';
import 'package:game/screen/test/game_view/game_item_view.dart';
import 'package:game/screen/test/test_logic.dart';
import 'package:provider/provider.dart';
enum AnswerType { quiz, spelling, matching, flash }

class TestScreen extends StatefulWidget {
  final String topicId;
  TestScreen(this.topicId);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with TickerProviderStateMixin {
  String get topicId => widget.topicId;

  late TestLogic testLogic;
  late TestGameModel gameModel;
  bool isSoundDataLoaded = false;

  //animation
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    print(
        'CHINHLT: Study Screen - init State: StudyModel: ${context.read<TestGameModel>()}');
    testLogic = TestLogic(context: context, topicId: topicId);

    gameModel = context.read<TestGameModel>();
    gameModel.addListener(listener);

    testLogic.loadData();

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
    final audioModel = context.read<AudioModel>();
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
      ),
      body: SafeArea(
        child: Consumer(
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
                        testLogic.navigateAfterFinishingStudy();
                      },
                    ),
                  ],
                ),
              );
            }

            GameObject? previousGame = gameModel.previousGame;
            gameModel.previousGame = gameModel.currentGames;
            print('CHINHLT: current game: ${gameModel.currentGames}');

            return Column(
              children: <Widget>[
                Expanded(
                  child: _renderCurrentGame(
                    gameModel.currentGames,
                    previousGame,
                  ),
                ),
                _renderContinueBtn(),
              ],
            );
          },
        ),
      ),
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
      onAnswer: testLogic.onAnswer,
    );
  }

  void startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  Container _renderContinueBtn() {
    GameObject? currentGame = context.read<TestGameModel>().currentGames;
    if (currentGame == null)
      return Container(
        child: null,
      );
    Color _color = Theme.of(context).backgroundColor;
    if (currentGame.gameObjectStatus == GameObjectStatus.waiting) {
      return Container(child: null);
    }
    return Container(
      child: MaterialButton(
        onPressed: testLogic.onContinue,
        clipBehavior: Clip.antiAlias,
        animationDuration: Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: _color,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(
              (currentGame.questionStatus == QuestionStatus.answeredCorrect &&
                  context.read<TestGameModel>().listGames!.isEmpty)
                  ? 'Finish'
                  : 'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    gameModel.removeListener(listener);
    super.dispose();
  }
}
