library database;

import 'package:game/model/core/topic.dart';

abstract class DatabaseService {
  Future<List<Topic>> loadTopicByType(int type, int subjectType, {String parentId});
}
