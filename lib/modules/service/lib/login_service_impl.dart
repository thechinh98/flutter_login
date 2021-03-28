import 'service.dart';
import 'package:database/database.dart';
class LoginServiceImpl implements LoginService {
  final DatabaseService dbService;

  LoginServiceImpl(this.dbService);
  @override
  int func() {
    dbService.func();
    return 2;
  }

}