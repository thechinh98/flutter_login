import 'package:game/model/database_model/topic_database.dart';
class Topic {
  String? id;
  String? title;
  String? parentId;
  int? questionNum;
  String? image;
  String? shortDes;
  int? type;
  int? practiceMode;
  int? indexes;
  String? level;
  bool isMain = false;
  Topic(
      {this.id,
      this.title,
      this.parentId,
      this.questionNum,
      this.type,
      this.image,
      this.indexes,
      this.practiceMode,
      this.shortDes});
  Topic.fromJson(Map<String, dynamic> map){
    getInfoTopic(map);
  }
  getInfoTopic(Map<String, dynamic> map){
    id = map[columnId];
    parentId = map[columnParentId];
    title = map[columnTitle];
    questionNum = map[columnQuestionNum];
    image = map[imageColumn] ?? "";
    shortDes = map[descriptionColumn] ?? "";
    type = map[typeColumn];
    practiceMode = map[practiceModeColumn];
    indexes = map[indexesColumn];
    level = map[levelColumn] ?? "";
  }
}
