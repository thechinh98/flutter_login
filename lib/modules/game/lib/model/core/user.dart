import 'package:game/model/database_model/done_test_database.dart';
import 'package:game/model/database_model/user_database.dart';
import 'dart:convert';
import 'done_test.dart';

class User{
  int? id;
  String? userName;
  String? password;
  List<DoneTest> listTestDone = [];
  List<int> listPracticeDone = [];
  User({this.id, this.userName, this.password});
  User.fromJson(Map<String, dynamic> map){
    id = map[idColumn] as int;
    userName = map[usernameColumn] as String;
    password = map[passwordColumn] as String;
   getListPracticeDone(map);
    getListTestDone(map);
  }
  getListTestDone(Map<String, dynamic> map){
    List<dynamic> listTest = [];
    if(map[listTestDoneColumn] != null && map[listTestDoneColumn] != ""){
      listTest = json.decode(map[listTestDoneColumn]);
    }
    for(int i = 0; i<listTest.length;i++){
      DoneTest doneTest = DoneTest(id: listTest[i][idField], title: listTest[i][titleField], point: listTest[i][pointField]);
      listTestDone.add(doneTest);
    }
  }
  getListPracticeDone(Map<String, dynamic> map){
    List<dynamic> listPractice = [];
    if(map[listPracticeDoneColumn] != null && map[listPracticeDoneColumn] != ""){
      listPractice= json.decode(map[listPracticeDoneColumn]);
    }
    for(int i = 0; i < listPractice.length; i++){
      listPracticeDone.add(int.parse(listPractice[i].toString()));
    }
  }
  bool checkIdTestDone(int id){
    for(var item in listTestDone){
      if(item.id == id){
        return true;
      }
    }
    return false;
  }

}