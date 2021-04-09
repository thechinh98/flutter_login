import 'dart:math';

import 'package:flutter/material.dart';

class TopicItemView extends StatelessWidget {
  const TopicItemView({
    Key? key,
    required this.topicNumber,
    required this.topicDetail,
    required this.press,
  }) : super(key: key);
  final String topicNumber;
  final String topicDetail;
  final GestureTapCallback press;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
