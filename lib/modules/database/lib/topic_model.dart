import 'package:database/constant.dart';
import 'package:database/database_service.dart';
import 'package:database/firebase_data_service_impl.dart';
import 'package:flutter/cupertino.dart';
import 'package:game/model/core/topic.dart';

class TopicModel extends ChangeNotifier {
  List<Topic> topics = [];
  int currentTopicType = 0;
  DatabaseService dbService = FirebaseServiceImpl();
  loadData({required int type,required int gameType,required String parentId}) async {
    topics.clear();
    this.currentTopicType = type;
    List<Topic> topicDb = [];

    print("CHINHLT: TOPIC MODEL - load data - topic type: $type");
    topicDb = await dbService.loadTopicByType(type, gameType, parentId: parentId);
    if (topicDb.isNotEmpty) {
      topicDb.forEach((element) {
        if(type == 1 && element.shortDes!.isEmpty) {
          return;
        } else {
          if(type == 1 && gameType == ieltsSubject){
            element.isMain = true;
          }
          topics.add(element);
        }
      });
      print("CHINHLT: TOPIC MODEL - load data - successfully");
    } else {
      print("TOPIC MODEL: Fetching data fail ");
    }
    notifyListeners();
  }
}
