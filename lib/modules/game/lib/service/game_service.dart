import 'package:game/model/core/question.dart';

abstract class GameService {
  Future<List<Question>> loadQuestionsByParentId({required String parentId});
  Future<List<Question>> loadTestQuestionsByParentId({required String parentId, required int subjectType});
  Future<List<Question>> loadChildQuestionList(
      Map<String, Question> mapHasChild);
  navigateAfterFinishingStudy();
}
