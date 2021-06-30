import 'package:game/model/core/question.dart';
import 'package:game/model/core/user.dart';

abstract class GameService {
  Future<List<Question>> loadQuestionsByParentId({required String parentId,required int subjectType});
  Future<List<Question>> loadTestQuestionsByParentId({required String parentId, required int subjectType});
  Future<List<Question>> loadChildQuestionList(
      Map<String, Question> mapHasChild, int subjectType);
  Future<User> loadUserByUsername({required String username});
  navigateAfterFinishingStudy();
}
