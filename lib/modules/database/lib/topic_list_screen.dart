import 'package:database/sql_repository.dart';
import 'package:database/topic_item_view.dart';
import 'package:database/topic_model.dart';
import 'package:flutter/material.dart';
import 'package:game/screen/study/study_screen.dart';
import 'package:game/screen/test/test_screen.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class TopicListScreen extends StatefulWidget {
  final int type;
  final String title;
  const TopicListScreen({Key? key, required this.type,required this.title}) : super(key: key);
  @override
  _TopicListScreenState createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late TopicModel topicModel;
  @override
  void initState() {
    // TODO: implement initState
    print(
        "CHINHLT: Topic List Screen - init state: Topic mode: ${context.read<TopicModel>()}");
    topicModel = context.read<TopicModel>();
    topicModel.loadData(type: widget.type);
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
                            topicNumber: _topicModel.topics[index].title!,
                            topicDetail: _topicModel.topics[index].shortDes!,
                            press: () {
                              if(widget.type == 2){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StudyScreen(_topicModel.topics[index].id!)));
                              } else if(widget.type == 3){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TestScreen(_topicModel.topics[index].id!)));
                              }
                            }),
                  )
                : Center(
                    child: Text("Empty Topic Data"),
                  ),
          );
        }),
      ),
    );
  }
}
