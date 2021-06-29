import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/database_model/question_database.dart';
import 'package:game/model/database_model/topic_database.dart';
import 'package:game/model/database_model/user_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class SQLiteRepository{
  factory SQLiteRepository(){
    if(_instance == null){
      _instance = SQLiteRepository._getInstance();
    }
    return _instance!;
  }
  static SQLiteRepository? _instance;
  SQLiteRepository._getInstance();
  static const DB_VERSION = 1;
  Database? _db;
  Database? _ieltsDb;
  Database? _userDb;
  String appDbName = 'data-$DB_VERSION.db';
  String dataDbName = 'data.db';

  String userAppDbName = 'user-$DB_VERSION.db';
  String userDbName = 'user.db';

  String ieltsAppDbName = 'ielts-$DB_VERSION.db';
  String ieltsDataDbName = 'ielts.db';

  Database get moduleDB => _db!;
  Database get ieltsDB => _ieltsDb!;
  Database get userDb => _userDb!;

  Future initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _checkAndCopyDatabase();
    await _checkAndCopyIeltsDatabase();
    await _checkAndCopyUserDatabase();

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, appDbName);
    _db = await openDatabase(path);

    String pathUser = join(documentsDirectory.path, userAppDbName);
    _userDb = await openDatabase(pathUser);

    String pathIelts = join(documentsDirectory.path, ieltsAppDbName);
    _ieltsDb = await openDatabase(pathIelts);

    await _createTable(_db);
    await _createTable(_ieltsDb);
    await _createUserTable(_userDb);
  }
  
  _checkAndCopyUserDatabase() async{
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
    String path = join(documentsDirectory.path, userAppDbName);
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
          "dbName found $userAppDbName documentsDirectory.path: ${documentsDirectory.path}");
    }
  }
  _checkAndCopyDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = documentsDirectory.listSync();
    for (var file in files) {
      String fileName = file.path.split('/').last;
      if (fileName.endsWith('.db') &&
          fileName.startsWith('data') &&
          !fileName.startsWith('data-$DB_VERSION.db')) {
        file.deleteSync(recursive: true);
      }
    }
    String path = join(documentsDirectory.path, appDbName);
    // print("PATH: $path");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      // print(
          // "dbName not found $appDbName documentsDirectory.path: ${documentsDirectory.path}");
      ByteData data;
      try {
        data = await rootBundle
            .load(join('packages/database/assets/data/', dataDbName));
      } catch (e) {
        data = await rootBundle.load(join('assets/data/', dataDbName));
      }
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
      // print(
      //     "dbName $appDbName copy success documentsDirectory.path: ${documentsDirectory.path}");
    } else {
      // print(
      //     "dbName found $appDbName documentsDirectory.path: ${documentsDirectory.path}");
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
          "dbName $ieltsAppDbName copy success documentsDirectory.path: ${documentsDirectory.path}");
    } else {
      print(
          "dbName found $ieltsAppDbName documentsDirectory.path: ${documentsDirectory.path}");
    }
  }

  Future _createTable(db) async {
    await db.transaction((txn) async {
      await txn.execute(createQuestionTable);
      // await txn.execute(createTopicTable);
    });
  }

  Future _createUserTable(userDb) async{
    await userDb.transaction((txn) async{
      await txn.execute(createUserTable);
    });
  }
}