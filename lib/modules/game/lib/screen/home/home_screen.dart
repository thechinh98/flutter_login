import 'package:flutter/material.dart';

import '../game_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  final String title = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      // body: Center(
      //   child: ElevatedButton(
      //     child: Text('Quiz Game'),
      //     onPressed: () {
      //       final topicId = '4536143782608896';
      //       Navigator.of(context).push(
      //         MaterialPageRoute(builder: (_) => StudyScreen(topicId)),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
