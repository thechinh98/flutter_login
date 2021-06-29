import 'package:database/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:game/model/core/user.dart';
import 'package:game/service/game_service_impl.dart';

class UserModel extends ChangeNotifier{
  List<User> listUser = [];
  User? currentUser;

  loadUserData({required int id}) async{
    reset();
    currentUser = await GameServiceImpl().loadUserById(id: id);
    notifyListeners();
  }
  reset(){
    listUser = [];
  }
}