import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dictionary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Copy asset DB if not exists
    if (!await databaseExists(path)) {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load(join('assets/databases', 'dictionary.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    _database = await openDatabase(path, version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS words_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT NOT NULL,
            meanings TEXT NOT NULL,
            pronunciation TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS favorites_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL,
            FOREIGN KEY (word_id) REFERENCES words_table(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS history_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL,
            timestamp INTEGER NOT NULL,
            FOREIGN KEY (word_id) REFERENCES words_table(id)
          )
        ''');
      },
    );
    return _database!;
  }
}