library database;

import 'package:game/model/core/topic.dart';

abstract class DatabaseService {
  int func() => 1;
  Future<List<Topic>> loadTopicByType(int type);
}
