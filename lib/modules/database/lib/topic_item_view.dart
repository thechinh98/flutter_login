import 'dart:math';

import 'package:flutter/material.dart';

class TopicItemView extends StatelessWidget {
  const TopicItemView({
    Key? key,
    required this.topicNumber,
    required this.topicDetail,
    required this.press,
    required this.isLearned,
    this.isMain = false,
  }) : super(key: key);
  final String topicNumber;
  final String topicDetail;
  final GestureTapCallback press;
  final bool isLearned;
  final bool isMain;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        !isMain ? _generateLearnedIcon() : Container(),
        GestureDetector(
          onTap: press,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
              borderRadius: BorderRadius.circular(30),
            ),
            child: RichText(
              text: TextSpan(
                  text: "$topicNumber\n",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                  children: [
                    TextSpan(
                      text: "$topicDetail",
                      style: TextStyle(fontSize: 13),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  _generateLearnedIcon() {
    return isLearned ? Icon(Icons.check) : Icon(Icons.radio_button_unchecked);
  }
}
