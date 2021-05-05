import 'package:game/model/database_model/choice_database.dart';
import 'package:uuid/uuid.dart';

class Choice {
  String? id;
  String parentId;

  // String testId;
  bool isCorrect;
  bool selected = false;
  String content;

  Choice(
      {this.id,
      required this.parentId,
      required this.content,
      required this.isCorrect});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
      columnIsCorrect: isCorrect ? 1 : 0,
      columnSelected: selected ? 1 : 0,
      columnParentId: parentId
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory Choice.fromMap(Map<String, dynamic> map, {int? questionId}) {
    Choice choice = Choice(
        parentId: map[columnParentId],
        content: map[columnContent],
        isCorrect: (map[columnIsCorrect] == 1) ? true : false);
    choice.id = map[columnId];
    choice.selected = (map[columnSelected] == 1) ? true : false;

    // content = map[_columnContent];
    // id = map[_columnId];
    // parentId = map[_columnParentId] ?? "";
    // // testId = map[_columnTestId] ?? "";
    // isCorrect = (map[_columnIsCorrect] == 1) ? true : false;
    // selected = (map[_columnSelected] == 1) ? true : false;
    return choice;
  }

  factory Choice.copyWith(Choice clone) {
    Choice choice = Choice(
        id: clone.id,
        parentId: clone.parentId,
        content: clone.content,
        isCorrect: clone.isCorrect);
    // id = clone.id;
    // isCorrect = clone.isCorrect;
    // parentId = clone.parentId;
    // content = clone.content;
    return choice;
  }

  factory Choice.cloneWrongChoice(Choice clone) {
    // id = Uuid().v1();
    // isCorrect = false;
    // parentId = clone.parentId;
    // content = clone.content;
    // selected = false;
    return Choice(
      id: Uuid().v1(),
      parentId: clone.parentId,
      content: clone.content,
      isCorrect: false,
    )..selected = false;
  }

  @override
  String toString() {
    return "choice: { id: $id, parentId: $parentId, isCorrect $isCorrect, content: $content }";
  }

  reset() {
    selected = false;
  }
}
