import 'package:database/sql_repository.dart';
import 'package:database/topic_item_view.dart';
import 'package:database/topic_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class TopicListScreen extends StatefulWidget {
  final int type;

  const TopicListScreen({Key? key, required this.type}) : super(key: key);
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
        title: Text("TOPIC SCREEN"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SizedBox(
          width: double.infinity,
          child: topicModel.topics.isNotEmpty
              ? ListView.builder(
                  itemCount: topicModel.topics.length,
                  itemBuilder: (BuildContext context, int index) =>
                      TopicItemView(
                          topicNumber: topicModel.topics[index].title!,
                          topicDetail: topicModel.topics[index].shortDes!,
                          press: () {
                            print(topicModel.topics[index].id);
                          }),
                )
              : Center(
                  child: Text("Empty Topic Data"),
                ),
        ),
      ),
    );
  }
}

