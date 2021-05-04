import 'package:database/database_service.dart';
import 'package:database/firebase_data_service_impl.dart';
import 'package:flutter/cupertino.dart';
import 'package:game/model/core/topic.dart';

class TopicModel extends ChangeNotifier {
  List<Topic> topics = [];
  int currentTopicType = 0;
  DatabaseService dbService = FirebaseServiceImpl();
  loadData({required int type}) async {
    topics.clear();
    this.currentTopicType = type;
    List<Topic> topicDb = [];

    print("CHINHLT: TOPIC MODEL - load data - topic type: $type");
    topicDb = await dbService.loadTopicByType(type);
    if (topicDb.isNotEmpty) {
      topicDb.forEach((element) {
        topics.add(element);
      });
      print("CHINHLT: TOPIC MODEL - load data - successfully");
    } else {
      print("TOPIC MODEL: Fetching data fail ");
    }
    notifyListeners();
  }
}
