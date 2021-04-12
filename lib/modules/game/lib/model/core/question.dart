import 'dart:convert';

import 'package:game/model/core/choice.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/utils/constant.dart';
import 'package:game/utils/utils.dart';


class Question {
  String? id;
  String? parentId;
  String? content;
  String? hint;
  String? explain;
  List<Choice>? choices;
  String? image;
  int? type;
  int? skill;
  String? sound;
  String? backSound;
  bool hasChild = false;
  QuestionStatus questionStatus = QuestionStatus.notAnswerYet;
  List<Question> children = [];
  bool? isChildQues = false;
  Question? parentQues;
  double? orderIndex;

  Question({this.id,
    this.content,
    this.hint,
    this.explain,
    this.type,
    this.isChildQues,
    this.parentQues,
    this.skill,
    this.orderIndex,
    this.choices,
    this.sound,
    this.backSound,
    this.parentId,
    // this.progress,
    this.image});

  Question.fromJson(Map<String, dynamic> map) {
    getInfoQues(map);
    switch (type) {
      case TYPE_CARD_NORMAL:
        getNormalQuestion(map);
        break;
      case TYPE_CARD_PARAGRAPH:
        hasChild = true;
        break;
      case TYPE_CARD_PARAGRAPH_CHILD:
        isChildQues = true;
        getNormalQuestion(map);
        break;
      default:
    }
  }

  getInfoQues(Map<String, dynamic> map) {
    id = map[columnId]?.toString() ?? "-1";
    parentId = map[columnParentId]?.toString() ?? "-1";
    content = map[columnContent] ?? "";
    choices = [];
    type = map[columnType] ?? TYPE_CARD_NORMAL;
    image = map[columnImage] ?? "";
    sound = ClientUtils.checkUrl(map[columnSound]) ?? "";
    backSound = ClientUtils.checkUrl(map[columnBackSound]) ?? "";
    hint = map[columnHint] ?? "";
    explain = map[columnExplain] ?? "";
    hint = map[columnHint] ?? "";
    skill = map[columnSkill] ?? -1;

    orderIndex = double.parse(map[orderIndex]?.toString() ?? "0");

    if (orderIndex! < 0) orderIndex = 0;
  }

  getNormalQuestion(Map<String, dynamic> map) {
    List<dynamic>? correctAnswer = [];
    List<dynamic>? inCorrectAnswer = [];
    if (map[columnCorrectAnswers] != null &&
        map[columnCorrectAnswers] != "") {
      correctAnswer = json.decode(map[columnCorrectAnswers]);
    }
    if (map[columnChoices] != null && map[columnChoices] != "") {
      inCorrectAnswer = json.decode(map[columnChoices]);
    }
    int index = 0;
    for (var i = 0; i < correctAnswer!.length; i++) {
      String choiceContent = correctAnswer[i].toString();
      Choice correctChoice = Choice(
          id: index.toString(),
          content: choiceContent,
          parentId: id!,
          isCorrect: true);
      choices!.add(correctChoice);
      index++;
    }
    for (var i = 0; i < inCorrectAnswer!.length; i++) {
      String choiceContent = inCorrectAnswer[i].toString();
      Choice correctChoice = Choice(
          id: index.toString(),
          content: choiceContent,
          parentId: id!,
          isCorrect: false);
      choices!.add(correctChoice);
      index++;
    }
    choices!.sort((a, b) => a.content.compareTo(b.content));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      columnContent: content,
      columnParentId: parentId,
      columnExplain: explain,
      columnSkill: skill,
      columnSound: sound,
      columnType: type,
      columnHint: hint,
    };
  }
}