import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    await db.execute('''CREATE TABLE mood(
    id INTEGER PRIMARY KEY,
    date TEXT NOT NULL UNIQUE,
    rating INTEGER NOT NULL)''');
  }
}
