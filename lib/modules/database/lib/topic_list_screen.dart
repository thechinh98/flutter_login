import 'package:database/constant.dart';
import 'package:database/sql_repository.dart';
import 'package:database/topic_item_view.dart';
import 'package:database/topic_model.dart';
import 'package:flutter/material.dart';
import 'package:game/model/core/topic.dart';
import 'package:game/model/core/user.dart';
import 'package:game/providers/user_model.dart';
import 'package:game/screen/game_screen.dart';
import 'package:game/utils/constant.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class TopicListScreen extends StatefulWidget {
  final String title;
  final int subjectType;
  final int type;
  final String parentId;
  const TopicListScreen(
      {Key? key,
      required this.title,
      required this.subjectType,
      required this.type,
      required this.parentId})
      : super(key: key);
  @override
  _TopicListScreenState createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late TopicModel topicModel;
  int get subjectType => widget.subjectType;
  int get type => widget.type;
  String get parentId => widget.parentId;
  @override
  void initState() {
    topicModel = context.read<TopicModel>();
    topicModel.loadData(type: type, gameType: subjectType, parentId: parentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer2<TopicModel, UserModel>(builder: (context, _topicModel, _userModel, child) {
          return SizedBox(
            width: double.infinity,
            child: _topicModel.topics.isNotEmpty
                ? ListView.builder(
                    itemCount: _topicModel.topics.length,
                    itemBuilder: (BuildContext context, int index) {
                      Topic currentTopic = _topicModel.topics[index];
                      User currentUser = _userModel.currentUser!;
                       return  TopicItemView(
                            isMain: currentTopic.isMain,
                            isLearned: (currentUser.listPracticeDone.contains(int.parse(currentTopic.id!)) || (currentUser.checkIdTestDone(int.parse(currentTopic.id!)))),
                            topicNumber: currentTopic.title!
                                .replaceAll("\n", " "),
                            topicDetail: currentTopic.shortDes!,
                            level: currentTopic.level ?? "",
                            press: () {
                              if (subjectType == ieltsSubject && type == 1) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TopicListScreen(
                                      title:
                                          "IELTS ${currentTopic.title!}",
                                      subjectType: ieltsSubject,
                                      type: 2,
                                      parentId: currentTopic.id!,
                                    ),
                                  ),
                                );
                              }else if(subjectType == toeicSubject && type == 3){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameScreen(
                                      topicId: currentTopic.id!,
                                      gameType: GAME_TEST_MODE,
                                      subjectType: subjectType,
                                    ),
                                  ),
                                );
                             } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameScreen(
                                      topicId: currentTopic.id!,
                                      gameType: GAME_STUDY_MODE,
                                      subjectType: subjectType,
                                    ),
                                  ),
                                );
                              }
                            });
                  })
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        }),
      ),
    );
  }
}
