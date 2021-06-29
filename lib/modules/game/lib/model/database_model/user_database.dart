final String tableUser = "User";
final String idColumn = "id";
final String usernameColumn = "username";
final String passwordColumn = "password";
final String listPracticeDoneColumn = "listPracticeDone";
final String listTestDoneColumn = "listTestDone";

final String createUserTable = '''
        create table IF NOT EXISTS $tableUser (
          $idColumn integer primary key,
          $usernameColumn text not null,
          $passwordColumn text not null,
          $listPracticeDoneColumn text,
          $listTestDoneColumn text)
        ''';