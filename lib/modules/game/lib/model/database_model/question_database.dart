
final String tableQuestion = "Question";
final String columnId = "id";
final String columnParentId = "parentId";
final String columnImage = 'image';
final String columnSound = 'sound';
final String columnHint = 'hint';
final String columnExplain = 'explain';
final String columnContent = 'content';
final String columnVideo = "video";
final String columnCorrectAnswers = "correctAnswers";
final String columnChoices = "choices";
final String orderIndex = "orderIndex";
final String columnType = "type";
final String columnSkill = "skill";
final String columnBackSound = "backSound";
final String createQuestionTable = '''
        create table IF NOT EXISTS $tableQuestion (
          $columnId text primary key,
          $columnParentId text not null,
          $columnContent text not null,
          $columnSound text,
          $columnBackSound text,
          $columnType integer,
          $orderIndex integer,
          $columnSkill integer,
          $columnImage text,
          $columnVideo text,
          $columnHint text,
          $columnCorrectAnswers text,
          $columnChoices text,
          $columnExplain text)
        ''';

enum QuestionStatus {
  delete,
  notAnswerYet ,
  answeredIncorrect,
  answeredCorrect
}
