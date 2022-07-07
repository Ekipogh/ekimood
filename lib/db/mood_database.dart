import 'package:ekimood/model/mood_category.dart';
import 'package:ekimood/model/mood_data.dart';
import 'package:ekimood/model/mood_icon.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/mood.dart';

class MoodDB {
  static final MoodDB instance = MoodDB._init();

  factory MoodDB() {
    return instance;
  }

  MoodDB._init();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("mood.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Mood table
    await db.execute('''CREATE TABLE ${Mood.tableName}(
    ${Mood.idField} INTEGER PRIMARY KEY,
    ${Mood.dateField} TEXT NOT NULL UNIQUE,
    ${Mood.ratingField} INTEGER NOT NULL);''');
    // Categories table
    await db.execute('''CREATE TABLE ${MoodCategory.tableName} (
    ${MoodCategory.idField} INTEGER PRIMARY KEY,
    ${MoodCategory.nameField} TEXT NOT NULL
    );''');
    // Icons table
    await db.execute('''CREATE TABLE ${MoodIcon.tableName}(
    ${MoodIcon.idField} INTEGER PRIMARY KEY,
    ${MoodIcon.iconField} INTEGER NOT NULL,
    ${MoodIcon.categoryIdField} INTEGER,
    FOREIGN KEY(${MoodIcon.categoryIdField}) REFERENCES ${MoodCategory.tableName}(${MoodCategory.idField})
    );''');
    await db.execute('''CREATE TABLE ${MoodData.tableName}(
    ${MoodData.idField} INTEGER PRIMARY KEY,
    ${MoodData.moodIdField} INTEGER,
    ${MoodData.categoryIdField} INTEGER,
    ${MoodData.iconIdField} INTEGER,
    ${MoodData.selectedField} INTEGER NOT NULL,
    FOREIGN KEY(${MoodData.moodIdField}) REFERENCES ${Mood.tableName}(${Mood.idField}),
    FOREIGN KEY(${MoodData.categoryIdField}) REFERENCES ${MoodCategory.tableName}(${MoodCategory.idField}),
    FOREIGN KEY(${MoodData.iconIdField}) REFERENCES ${MoodIcon.tableName}(${MoodIcon.idField})
    );''');
    MoodCategory.initDefaultCategories();
  }
}
