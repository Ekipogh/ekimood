import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_category.dart';
import 'package:ekimood/model/mood_icon.dart';
import 'package:sqflite/sqflite.dart';

class Mood {
  Mood({this.id, required this.date, required this.rating}){
    fillCategories();
  }

  static String tableName = "mood";
  static String idField = "id";
  static String dateField = "date";
  static String ratingField = "rating";

  final int? id;
  final DateTime date;
  late int rating;
  List<MoodCategory> categories = [];

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
    if (mood != null) {
      await mood.remove();
    }
    final id = await db.insert(tableName, toMap());
    // Save data
    await saveData(db, id);
    return id;
  }

  saveData(Database db, int id) async {
    const String dataTableName = "data";
    const String moodId = "moodId";
    const String categoryId = "categoryId";
    const String iconId = "iconId";
    const String selectedField = "selected";
    for (MoodCategory category in categories) {
      for (MoodIcon icon in category.icons) {
        db.insert(dataTableName, {
          moodId: id,
          categoryId: category.id,
          iconId: icon.id,
          selectedField: icon.selected
        });
      }
    }
  }

  loadData() async {
    final db = await MoodDB.instance.database;
    final res = await db.query("data", where: "moodId = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      for (var row in res) {
        var categoryId = row["categoryId"] as int;
        MoodCategory? category = findCategoryById(categoryId);
        if (category != null) {
          var iconId = row["iconId"] as int;
          MoodIcon? icon = category.findIconById(iconId);
          if (icon != null) {
            icon.selected = row["selected"] as bool;
          } else {
            throw Exception("Can't find icon with id: $iconId "
                "in category with id: $categoryId");
          }
        } else {
          throw Exception("Can't find category with id: $categoryId");
        }
      }
    }
  }

  static Future<Mood?> findByDate(DateTime date) async {
    final db = await MoodDB.instance.database;
    final res = await db.query(tableName,
        where: '$dateField = ?', whereArgs: [date.toIso8601String()]);
    if (res.isNotEmpty) {
      Mood mood = Mood.fromMap(res.first);
      mood.fillCategories();
      return mood;
    }
    return null;
  }

  Future<int> remove() async {
    final db = await MoodDB.instance.database;
    return await db.delete(tableName, where: '$idField = ?', whereArgs: [id]);
  }

  fillCategories() async {
    final db = await MoodDB.instance.database;
    final res = await db.query(MoodCategory.tableName);
    if (res.isNotEmpty) {
      for (var element in res) {
        MoodCategory category = MoodCategory.fromMap(element);
        category.fillIcons();
        categories.add(category);
      }
    }
  }

  MoodCategory? findCategoryById(int id) {
    for (var category in categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }
}
