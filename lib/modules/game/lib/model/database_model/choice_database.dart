final String tableChoice = 'Choice';
final String columnId = 'id';
final String columnParentId = 'parentId';
final String columnSelected = 'selected';
final String columnTestId = 'testId';
final String columnContent = 'content';
final String columnIsCorrect = 'isCorrect';

final String createChoiceTable = '''
        create table IF NOT EXISTS $tableChoice (
          $columnId text primary key,
          $columnParentId text,
          $columnSelected boolean,
          $columnIsCorrect boolean,
          // $columnTestId text,
          $columnContent text not null)
        ''';
