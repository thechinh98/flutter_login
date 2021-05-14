// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:game/components/new_my_sound.dart';
import 'package:flutter/material.dart';
import 'package:game/components/text_content.dart';
import 'package:game/model/core/choice.dart';
import 'package:game/model/core/face.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/para_game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';

import '../../../game_screen.dart';

class ParagraphView extends StatelessWidget {
  final ParaGameObject gameObject;
  final ScrollController _scrollController = ScrollController();

  ParagraphView({
    required this.gameObject,
  });

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          _renderSound(),
          _renderParagraph(gameObject),
          _renderImage(gameObject),
          _buildHint(gameObject),
          gameObject.children.isNotEmpty ?_buildChildContent() : Container(),
        ],
      ),
    );
  }

  Container _renderParagraph(GameObject tempGameObject) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: TextContent(
        face: tempGameObject.question,
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
  Container _renderAnswer(GameObject tempGameObject) {
    Choice choice = (tempGameObject as QuizGameObject).choices[0];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: TextContent(
        face: Face(content: choice.content),
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }

  Container _buildHint(GameObject tempGameObject) {
    if(tempGameObject.hint != null) {
      return Container(
        width: double.infinity,
        child: Center(
          child: TextContent(
            face: tempGameObject.hint!,
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildChildContent() {
    return SizedBox(
      height: 600,
      child: ListView.builder(
          itemCount: gameObject.children.length,
          itemBuilder: (BuildContext context, int index) {
            GameObject indexGameObject = gameObject.children[index];
            return SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  _renderParagraph(indexGameObject),
                  _renderAnswer(indexGameObject),
                  // _buildHint(indexGameObject),
                  // _renderImage(indexGameObject),
                ],
              ),
            );
          }),
    );
  }

  Container _renderImage(GameObject tempGameObject) {
    if (tempGameObject.question.image != null) {
      return Container(
        width: double.infinity,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: CachedNetworkImage(
          imageUrl: tempGameObject.question.image!,
          placeholder: (context, url) => new SizedBox(
            child: CircularProgressIndicator(),
            height: 10,
            width: 10,
          ),
        ),
      );
    }
    return Container();
  }

  _renderSound() {
    if (gameObject != null &&
        gameObject.question.sound != null &&
        gameObject.question.sound!.isNotEmpty) {
      return NewGameSound(
        disabled:  false,
        questionId: gameObject.id!,
        key: Key(gameObject.id.toString() + gameObject.id.toString()),
      );
    } else if (gameObject.children.isNotEmpty &&
        gameObject.children[0].question.sound != null) {
      return NewGameSound(
        disabled: false,
        questionId: gameObject.children[0].id!,
        key: Key(gameObject.id.toString()),
      );
    } else
      return Container();
  }
}
