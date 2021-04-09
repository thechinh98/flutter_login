import 'package:game/model/core/topic.dart';

abstract class DatabaseService {
 List<Topic> loadTopic(int type);

}