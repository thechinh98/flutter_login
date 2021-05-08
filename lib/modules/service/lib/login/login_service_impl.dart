import '../service.dart';
import 'package:database/database_service.dart';
class LoginServiceImpl implements LoginService {
  final DatabaseService dbService;

  LoginServiceImpl(this.dbService);
  @override
  int func() {
    return 2;
  }

}