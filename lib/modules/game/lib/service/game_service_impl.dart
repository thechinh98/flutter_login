
import 'package:game/model/core/question.dart';
import 'package:game/repository/sql_repository.dart';
import 'package:game/route/router_service.dart';
import 'package:game/route/routes.dart';
import 'package:game/service/game_service.dart';

class GameServiceImpl implements GameService {
  @override
  Future<List<Question>> loadQuestionsByParentId(
      {required String parentId}) async {
    return await SqfliteRepository().loadQuestionsByParentId(parentId: parentId);
  }

  @override
  Future<List<Question>> loadTestQuestionsByParentId(
      {required String parentId}) async {
    return await SqfliteRepository().loadTestQuestionsByParentId(parentId: parentId);
  }

  @override
  Future<List<Question>> loadChildQuestionList(
      Map<String, Question> mapHasChild) async {
    return await SqfliteRepository().loadChildQuestionList(mapHasChild);
  }

  @override
  navigateAfterFinishingStudy() {
    NavigationService().pushNamedAndRemoveUntil(
        ROUTE_RESULT_SCREEN, (route) => route.settings.name == ROUTER_HOME);
  }
}
