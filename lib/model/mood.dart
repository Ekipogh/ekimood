import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_category.dart';

import 'mood_data.dart';

class Mood {
  Mood({this.id, required this.date, required this.rating}) {
    for (MoodCategory category in MoodCategory.categoriesList) {
      data.add(MoodData(category: category, mood: this));
    }
  }

  static String tableName = "mood";
  static String idField = "id";
  static String dateField = "date";
  static String ratingField = "rating";

  final int? id;
  final DateTime date;
  late int rating;
  late List<MoodData> data;

  Map<String, dynamic> toMap() {
    return {
      idField: id,
      dateField: date.toIso8601String(),
      ratingField: rating,
    };
  }

  static Mood fromMap(Map<String, dynamic> map) {
    return Mood(
        id: map[idField],
        date: DateTime.parse(map[dateField]),
        rating: map[ratingField]);
  }

  save() async {
    final db = await MoodDB.instance.database;
    var mood = await Mood.findByDate(date);
    // Replace existing mood
    if (mood != null) {
      await mood.remove();
    }
    final id = await db.insert(tableName, toMap());
    // Save data
    for (MoodData dataElement in data) {
      await dataElement.save();
    }
    return id;
  }

  static Future<Mood?> findByDate(DateTime date) async {
    final db = await MoodDB.instance.database;
    final res = await db.query(tableName,
        where: '$dateField = ?', whereArgs: [date.toIso8601String()]);
    if (res.isNotEmpty) {
      Mood mood = Mood.fromMap(res.first);
      mood.loadData();
      return mood;
    }
    return null;
  }

  Future<int> remove() async {
    final db = await MoodDB.instance.database;
    return await db.delete(tableName, where: '$idField = ?', whereArgs: [id]);
  }

  loadData() async {
    final db = await MoodDB().database;
    for (var dataElement in data) {
      final res = await db.query(MoodData.tableName,
          where: '${MoodData.moodIdField} = ? AND ${MoodData.categoryIdField}',
          whereArgs: [id, dataElement.category.id]);
      for (var row in res) {
        dataElement.set(row[MoodData.iconIdField] as int,
            row[MoodData.selectedField] == "0" ? false : true);
      }
    }
  }
}
