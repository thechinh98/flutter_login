// Dart imports:
import 'dart:convert';

import 'package:game/model/core/question.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/database_model/question_progress_database.dart';


class QuestionProgress {
  late int id;
  String questionId = "";
  String userId = "";
  bool bookmark = false;
  int boxNum =
      0; //-2 la sai 2 lan, -1 tra loi sai 1 lan, 0 khoi tao, 1 la tra loi dung 1 lan gan nhat, 2 la tra loi dung 2 lan lien tiep
  List<int> histories = <int>[];
  List<int> testHistories = <int>[];
  List<int> testTimes = <int>[];
  List<int> times = <int>[];
  String lastUpdate = "-1";

  int get lastResult {
    if (histories != null && histories.isNotEmpty) {
      return histories.last;
    } else
      return 0;
  }

  QuestionProgress();

  QuestionProgress.init(Question _question) {
    questionId = _question.id!;
    lastUpdate = new DateTime.now().millisecondsSinceEpoch.toString();
  }
  QuestionProgress.fromMap(Map<String, dynamic> map) {
    if (map['histories'] != null) {
      histories = jsonDecode(map['histories']).cast<int>();
    }
    if (map['times'] != null) {
      times = jsonDecode(map['times']).cast<int>();
    }
    if (map['testHistories'] != null) {
      testHistories = jsonDecode(map[columnTestHistories]).cast<int>();
    }
    if (map['testTimes'] != null) {
      testTimes = jsonDecode(map[columnTestTimes]).cast<int>();
    }
    id = map['id'];
    userId = map['userId'];
    questionId = map['questionId'];
    bookmark = map[columnBookmark] > 0 ? true : false;
    boxNum = map['boxNum'] ?? 0;
    lastUpdate = map['lastUpdate'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[columnQuestionId] = questionId;
    map[columnBoxNum] = boxNum;
    map[columnUserId] = userId;
    map[columnBookmark] = bookmark ? 1 : 0;
    map[columnHistories] = jsonEncode(histories);
    map[columnTimes] = jsonEncode(times);
    map[columnTestHistories] = jsonEncode(testHistories);
    map[columnTestTimes] = jsonEncode(testTimes);
    if (id != null) {
      map["id"] = id;
    }
    map[columnLastUpdate] = lastUpdate;
    return map;
  }

  updateQuestionProgress(int _status,
      {bool testMode = false, int timeAnswer = -1}) {
    if (histories != null && histories.length >= 5) {
      histories.removeAt(0);
    }
    if (!testMode) {
      histories.add(_status);
      times.add(timeAnswer);
      if (_status == QuestionStatus.answeredCorrect) {
        if (boxNum < 2) {
          boxNum += 1;
          if (boxNum == 0) {
            boxNum += 1;
          }
        }
      } else {
        if (boxNum > -1) {
          boxNum -= 1;
          if (boxNum == 0) {
            boxNum -= 1;
          }
        }
      }
    } else {
      testHistories.add(_status);
      testTimes.add(timeAnswer);
    }
    lastUpdate = new DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  String toString() {
    return 'Question Progress: id: $id ----- $questionId --- histories: ${histories.length} --- boxNum: $boxNum -- lastUpdate: $lastUpdate';
  }
}
