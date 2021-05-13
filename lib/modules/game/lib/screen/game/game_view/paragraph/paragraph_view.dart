// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:game/components/new_my_sound.dart';
import 'package:flutter/material.dart';
import 'package:game/components/text_content.dart';
import 'package:game/model/core/choice.dart';
import 'package:game/model/core/face.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/para_game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/screen/game/game_view/game_item_view.dart';
import 'package:game/utils/constant.dart';

import '../../../game_screen.dart';

class ParagraphView extends StatelessWidget {

  final ParaGameObject gameObject;
  final ScrollController _scrollController = ScrollController();

  ParagraphView({required this.gameObject,});

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
          // _renderSound(),
          _renderParagraph(),
          _renderImage(),
          _buildHint(),
        ],
      ),
    );
  }


  Container _renderParagraph() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: TextContent(
        face: gameObject.question,
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }

  Container _buildHint() {
      return Container(
        width: double.infinity,
        child: Center(
          child: TextContent(
            face: gameObject.hint,
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
      );
  }

  Container _renderImage() {
    if (gameObject.question.image != null) {
      print(gameObject.question.image);
      return Container(
        width: double.infinity,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: CachedNetworkImage(
          imageUrl: gameObject.question.image!,
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
    // if (gameObject.parent != null &&
    //     gameObject.parent!.question.sound != null &&
    //     gameObject.parent!.question.sound!.isNotEmpty) {
    //   return NewGameSound(
    //     disabled: onAnswer == null ? true : false,
    //     questionId: gameObject.parent!.id!,
    //     key: Key(gameObject.parent!.id.toString() + gameObject.id.toString()),
    //   );
    // } else if (gameObject.question.sound != null &&
    //     gameObject.question.sound!.isNotEmpty) {
    //   return NewGameSound(
    //     disabled: onAnswer == null ? true : false,
    //     questionId: gameObject.id!,
    //     key: Key(gameObject.id.toString()),
    //   );
    // } else
    //   return Container();
  }

}

