import 'package:database/sql_repository.dart';
import 'package:game/model/core/topic.dart';
import 'package:game/utils/request.dart';
import 'package:sqflite/sqflite.dart';
import 'package:game/model/database_model/topic_database.dart';

import 'database_service.dart';

class FirebaseServiceImpl implements DatabaseService {
  Database _db = SQLiteRepository().moduleDb;
  @override
  int func() {
    // TODO: implement func
    throw UnimplementedError();
  }

  @override
  Future<List<Topic>> loadTopicByType(int type) async {
    List<Topic> topics = [];
    final maps = await requestApi(call: () => _db.query("$tableTopic", where: 'type = $type', orderBy: "CAST(substr(title, instr(title, ' ')) as INTEGER)" ), defaultValue: []);
    if(maps.length > 0) {
      for (var item in maps) {
        Topic topic = Topic.fromJson(item);
        topics.add(topic);
        print("Get topic from Json");
      }
    }
    return topics;
  }

}