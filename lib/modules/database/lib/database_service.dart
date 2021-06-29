library database;

import 'package:game/model/core/topic.dart';
import 'package:game/model/core/user.dart';

abstract class DatabaseService {
  Future<List<Topic>> loadTopicByType(int type, int subjectType, {String parentId});
  Future<List<User>> loadUser();
}
