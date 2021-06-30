import 'package:database/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:game/model/core/done_test.dart';
import 'package:game/model/core/user.dart';
import 'package:game/service/game_service_impl.dart';

class UserModel extends ChangeNotifier {
  List<User> listUser = [];
  User? currentUser;
  loadUserData({required String username}) async {
    reset();
    currentUser = await GameServiceImpl().loadUserByUsername(username: username);
    notifyListeners();
  }

  reset() {
    listUser = [];
  }

  addPracticeDone(int id) {
    if (!currentUser!.listPracticeDone.contains(id)) {
      currentUser!.listPracticeDone.add(id);
    }
    notifyListeners();
  }
  addTestDone(DoneTest doneTest){
    if(currentUser!.checkIdTestDone(doneTest.id)){
      currentUser!.listTestDone.removeWhere((element) => element.id == doneTest.id);
    }
    currentUser!.listTestDone.add(doneTest);
    notifyListeners();
  }
}
