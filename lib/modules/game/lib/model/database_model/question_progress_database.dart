final String tableQuestionProgress = 'QuestionProgress';
final String columnId = 'id';
final String columnUserId = "userId";
final String columnQuestionId = 'questionId';
final String columnBoxNum = 'boxNum';
final String columnBookmark = 'bookmark';
final String columnTimesAnswered = 'timesAnswered';
final String columnHistories = 'histories';
final String columnTimes = "times";
final String columnTestHistories = "testHistories";
final String columnLastUpdate = "lastUpdate";
final String columnTestTimes = "testTimes";
final String createQuestionProgressTable = '''
        create table IF NOT EXISTS $tableQuestionProgress (
          $columnId integer primary key autoincrement ,
          $columnQuestionId text,
          $columnUserId text,
          $columnHistories text,
          $columnTimes text,
          $columnTestHistories text,
          $columnTestTimes text,
          $columnTimesAnswered text,
          $columnBoxNum integer,
          $columnLastUpdate text,
          $columnBookmark integer)
        ''';