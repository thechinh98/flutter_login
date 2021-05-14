import 'package:database/constant.dart';
import 'package:database/sql_repository.dart';
import 'package:database/topic_item_view.dart';
import 'package:database/topic_model.dart';
import 'package:flutter/material.dart';
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
    print(
        "CHINHLT: Topic List Screen - init state: Topic mode: ${context.read<TopicModel>()}");
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
        child: Consumer<TopicModel>(builder: (context, _topicModel, child) {
          return SizedBox(
            width: double.infinity,
            child: _topicModel.topics.isNotEmpty
                ? ListView.builder(
                    itemCount: _topicModel.topics.length,
                    itemBuilder: (BuildContext context, int index) =>
                        TopicItemView(
                            topicNumber: _topicModel.topics[index].title!
                                .replaceAll("\n", " "),
                            topicDetail: _topicModel.topics[index].shortDes!,
                            press: () {
                              if (subjectType == ieltsSubject && type == 1) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TopicListScreen(
                                      title:
                                          "IELTS ${_topicModel.topics[index].title!}",
                                      subjectType: ieltsSubject,
                                      type: 2,
                                      parentId: _topicModel.topics[index].id!,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameScreen(
                                      topicId: _topicModel.topics[index].id!,
                                      gameType: GAME_STUDY_MODE,
                                      subjectType: subjectType,
                                    ),
                                  ),
                                );
                              }
                            }),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        }),
      ),
    );
  }
}
