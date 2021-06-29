import 'package:database/constant.dart';
import 'package:database/sql_repository.dart';
import 'package:game/model/core/topic.dart';
import 'package:game/model/core/user.dart';
import 'package:game/model/database_model/user_database.dart';
import 'package:game/utils/request.dart';
import 'package:sqflite/sqflite.dart';
import 'package:game/model/database_model/topic_database.dart';

import 'database_service.dart';

class FirebaseServiceImpl implements DatabaseService {
  Database _db = SQLiteRepository().moduleDB;
  Database _ieltsDb = SQLiteRepository().ieltsDB;
  @override
  Future<List<Topic>> loadTopicByType(int type, int subjectType,
      {String? parentId}) async {
    Database? tempDB;
    if (subjectType == toeicSubject) {
      tempDB = _db;
    } else if (subjectType == ieltsSubject) {
      tempDB = _ieltsDb;
    }
    List<Topic> topics = [];
    String conditionString = '';
    if (type == 2 && parentId != "") {
      conditionString = 'type = $type AND parentId = $parentId';
      print("DATABASE: Get IELTS TOPIC");
    } else {
      conditionString = 'type = $type';
    }
    final maps = await requestApi(
        call: () => tempDB!.query("$tableTopic",
            where: conditionString,
            orderBy: "CAST(substr(title, instr(title, ' ')) as INTEGER)"),
        defaultValue: []).then((value){
    });
    if (maps.length > 0) {
      for (var item in maps) {
        Topic topic = Topic.fromJson(item);
        if(){
          topic.
        }
        topics.add(topic);
      }
    }
    return topics;
  }

  @override
  Future<List<User>> loadUser() async {
    Database _userDb = SQLiteRepository().userDb;
    List<User> users = [];
    final maps = await requestApi(
        call: () => _userDb.query("$tableUser",),
        defaultValue: []);
    if (maps.length > 0) {
      for (var item in maps) {
        User user = User.fromJson(item);
        users.add(user);
      }
    }
    return users;
  }
}
