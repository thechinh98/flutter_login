import 'dart:math';

import 'package:flutter/material.dart';

class TopicItemView extends StatelessWidget {
  const TopicItemView({
    Key? key,
    required this.topicNumber,
    required this.topicDetail,
    required this.press,
    this.isLearned = false,
    this.isMain = false,
    this.level = "",
  }) : super(key: key);
  final String topicNumber;
  final String topicDetail;
  final GestureTapCallback press;
  final bool isLearned;
  final bool isMain;
  final String level;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          !isMain ? _generateLearnedIcon() : Container(),
          SizedBox(width: 5),
          Expanded(
            child: GestureDetector(
              onTap: press,
              child: Card(
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.1),
                color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ListTile(
                  title: Text(
                    "$topicNumber",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                  subtitle: Text("$topicDetail"),
                  trailing: level != ""
                      ? Text("Target: $level",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white))
                      : Text(""),
                ),
              ),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Container(
              //       height: 60,
              //       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //       decoration: BoxDecoration(
              //         color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
              //             .withOpacity(1.0),
              //         borderRadius: BorderRadius.circular(30),
              //       ),
              //       child: RichText(
              //         text: TextSpan(
              //             text: "$topicNumber\n",
              //             style: TextStyle(fontSize: 17, color: Colors.white),
              //             children: [
              //               TextSpan(
              //                 text: "$topicDetail",
              //                 style: TextStyle(fontSize: 13),
              //               ),
              //             ]),
              //       ),
              //     ),
              //     Text("$level", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)
              //   ],
              // ),
            ),
          ),
        ],
      ),
    );
  }

  _generateLearnedIcon() {
    return isLearned
        ? Icon(
            Icons.check,
            size: 30,
          )
        : Icon(
            Icons.radio_button_unchecked,
            size: 30,
          );
  }
}
