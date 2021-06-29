import 'dart:io';
import 'dart:typed_data';

import 'package:database/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/core/user.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/database_model/user_database.dart';
import 'package:game/utils/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class SqfliteRepository {
  factory SqfliteRepository() {
    if (_instance == null) {
      _instance = SqfliteRepository._getInstance();
    }
    return _instance!;
  }

  static SqfliteRepository? _instance;

  SqfliteRepository._getInstance();

  static const DB_VERSION = 1;
  Database? _toeicDb;
  Database? _ieltsDb;
  Database? _userDb;
  String toeicAppDbName = 'toeic-$DB_VERSION.db';
  String toeicDbName = 'toeic.db';

  String userAppDbName = 'user-$DB_VERSION.db';
  String userDbName = 'user.db';

  String ieltsAppDbName = 'ielts-$DB_VERSION.db';
  String ieltsDataDbName = 'ielts.db';
  String userIeltsDbName = 'user_ielts_data.db';

  Database get toeicDb => _toeicDb!;

  Database get ieltsDB => _ieltsDb!;

  Database get userDataDb => _userDb!;

  Future initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _checkAndCopyToeicDatabase();
    await _checkAndCopyIeltsDatabase();
    await _checkAndCopyUserDatabase();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, toeicAppDbName);
    String pathIelts = join(documentsDirectory.path, ieltsAppDbName);
    String pathUser = join(documentsDirectory.path, userAppDbName);

    _toeicDb = await openDatabase(path);
    _ieltsDb = await openDatabase(pathIelts);
    _userDb = await openDatabase(pathUser);

    await _createTable(_toeicDb);
    await _createTable(_ieltsDb);
    await _createTable(_userDb);
  }

  _checkAndCopyToeicDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = documentsDirectory.listSync();
    for (var file in files) {
      String fileName = file.path.split('/').last;
      if (fileName.endsWith('.db') &&
          fileName.startsWith('toeic') &&
          !fileName.startsWith('toeic-$DB_VERSION.db')) {
        file.deleteSync(recursive: true);
      }
    }
    String path = join(documentsDirectory.path, toeicAppDbName);
    print("path: $path");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      print(
          "dbName not found $toeicAppDbName documentsDirectory.path: ${documentsDirectory.path}");
      ByteData data;
      try {
        data = await rootBundle
            .load(join('packages/game/assets/data/', toeicDbName));
      } catch (e) {
        data = await rootBundle.load(join('assets/data/', toeicDbName));
      }
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    } else {
      print(
          "dbName found $toeicAppDbName documentsDirectory.path: ${documentsDirectory.path}");
    }
  }

  _checkAndCopyUserDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = documentsDirectory.listSync();
    for (var file in files) {
      String fileName = file.path.split('/').last;
      if (fileName.endsWith('.db') &&
          fileName.startsWith('user') &&
          !fileName.startsWith('user-$DB_VERSION.db')) {
        file.deleteSync(recursive: true);
      }
    }
    String path = join(documentsDirectory.path, userDbName);
    print("path: $path");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      print(
          "dbName not found $userAppDbName documentsDirectory.path: ${documentsDirectory.path}");
      ByteData data;
      try {
        data = await rootBundle
            .load(join('packages/game/assets/data/', userDbName));
      } catch (e) {
        data = await rootBundle.load(join('assets/data/', userDbName));
      }
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    } else {
      print(
          "dbName found $userDbName documentsDirectory.path: ${documentsDirectory.path}");
    }
  }

  _checkAndCopyIeltsDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = documentsDirectory.listSync();
    for (var file in files) {
      String fileName = file.path.split('/').last;
      if (fileName.endsWith('.db') &&
          fileName.startsWith('ielts') &&
          !fileName.startsWith('ielts-$DB_VERSION.db')) {
        file.deleteSync(recursive: true);
      }
    }
    String path = join(documentsDirectory.path, ieltsAppDbName);
    print("path: $path");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      print(
          "dbName not found $ieltsAppDbName documentsDirectory.path: ${documentsDirectory.path}");
      ByteData data;
      try {
        data = await rootBundle
            .load(join('packages/game/assets/data/', ieltsDataDbName));
      } catch (e) {
        data = await rootBundle.load(join('assets/data/', ieltsDataDbName));
      }
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
      print(
          "dbName $ieltsAppDbName copy successs documentsDirectory.path: ${documentsDirectory.path}");
    } else {
      print(
          "dbName found $ieltsAppDbName documentsDirectory.path: ${documentsDirectory.path}");
    }
  }

  Future _createTable(db) async {
    await db.transaction((txn) async {
      await txn.execute(createQuestionTable);
    });
  }

  Future<List<Question>> loadChildQuestionList(
      Map<String, Question> mapHasChild, int subjectType) async {
    List<Question> results = [];
    String sql = '''
    select * from $tableQuestion as q where q.parentId in ( ''';
    mapHasChild.forEach((String key, Question question) {
      sql += '$key,';
    });
    sql = sql.substring(0, sql.length - 1);
    sql += ')';
    Database? _tempDb;
    if (subjectType == ieltsSubject) {
      _tempDb = _ieltsDb;
    } else if (subjectType == toeicSubject) {
      _tempDb = _toeicDb;
    }
    List<Map<String, dynamic>> maps = await requestApi<
        List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      call: () => _tempDb!.rawQuery(sql),
      defaultValue: [],
    );
    if (maps.length > 0) {
      maps.forEach((element) {
        Question question = Question.fromJson(element);
        question.parentQues = mapHasChild[question.parentId!];
        double parentOrderIndex = mapHasChild[question.parentId!]!.orderIndex!;
        if (parentOrderIndex < 0) {
          parentOrderIndex = 0;
        }
        question.orderIndex = parentOrderIndex + (question.orderIndex!) / 10;
        // print(parentOrderIndex);
        results.add(question);
      });
    }
    return results;
  }

  Future<List<Question>> loadQuestionsByParentId(
      {required String parentId, required int subjectType}) async {
    List<Question> result = [];
    Database? _tempDb;
    if (subjectType == ieltsSubject) {
      _tempDb = _ieltsDb;
    } else if (subjectType == toeicSubject) {
      _tempDb = _toeicDb;
    }
    final maps = await requestApi<List<Map>, List<Map>>(
      call: () => _tempDb!.query(
        "$tableQuestion",
        where: '"parentId" = $parentId',
      ),
      defaultValue: [],
    );

    if (maps.length > 0) {
      for (var item in maps) {
        Question question = Question.fromJson(item as Map<String, dynamic>);
        result.add(question);
      }
    }
    if (result.length < 5) {
      return result;
    } else {
      return result.sublist(0, 5);
    }
  }

  Future<List<Question>> loadTestQuestionsByParentId(
      {required String parentId, required gameType}) async {
    Database? _tempDb;
    List<Question> result = [];
    if (gameType == ieltsSubject) {
      _tempDb = _ieltsDb;
    } else if (gameType == toeicSubject) {
      _tempDb = _toeicDb;
    }
    final maps = await requestApi<List<Map>, List<Map>>(
      call: () => _tempDb!.query(
        "$tableQuestion",
        where: '"parentId" = $parentId',
      ),
      defaultValue: [],
    );

    if (maps.length > 0) {
      for (var item in maps) {
        Question question = Question.fromJson(item as Map<String, dynamic>);
        result.add(question);
      }
    }
    return result;
  }

  Future<User>  loadUserByUsername({required int id}) async {
    User user = User();
    List<User> users = [];
    final maps = await requestApi(
        call: () =>
            _userDb!.query("$tableUser", where: '"id" = $id'),
        defaultValue: []);
    if (maps.length == 1) {
      for (var item in maps) {
        User user = User.fromJson(item);
        users.add(user);
      }
    } else {
      print("Duplicated username");
    }
    user = users[0];
    return user;
  }
}
