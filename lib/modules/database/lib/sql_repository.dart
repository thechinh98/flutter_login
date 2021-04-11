import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/question.dart';
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
  String appDbName = 'data-$DB_VERSION.db';
  String dataDbName = 'data.db';
  String userDbName = 'user_data.db';
  Database get moduleDb => _db!;

  Future initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _checkAndCopyDatabase();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, appDbName);
    _db = await   openDatabase(path);

    await _createTable(_db);
    return _db;
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
    print("PATH: $path");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      print(
          "dbName not found $appDbName documentsDirectory.path: ${documentsDirectory.path}");
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
      print(
          "dbName $appDbName copy success documentsDirectory.path: ${documentsDirectory.path}");
    } else {
      print(
          "dbName found $appDbName documentsDirectory.path: ${documentsDirectory.path}");
    }
  }

  Future _createTable(db) async {
    await db.transaction((txn) async {
      await txn.execute(createQuestionTable);
    });
  }
}