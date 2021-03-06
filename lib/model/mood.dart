import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_category.dart';

class Mood {
  Mood({this.id, required this.date, required this.rating});

  final int? id;
  final DateTime date;
  late int rating;
  List<MoodCategory> categories = [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'rating': rating,
    };
  }

  static Mood fromMap(Map<String, dynamic> map) {
    return Mood(
        id: map["id"],
        date: DateTime.parse(map["date"]),
        rating: map["rating"]);
  }

  save() async {
    final db = await MoodDB.instance.database;
    var mood = await Mood.findByDate(date);
    if (mood != null) {
      await mood.remove();
    }
    final id = await db.insert("mood", toMap());
    return id;
  }

  static Future<Mood?> findByDate(DateTime date) async {
    final db = await MoodDB.instance.database;
    final res = await db
        .query("mood", where: 'date = ?', whereArgs: [date.toIso8601String()]);
    return res.isNotEmpty ? Mood.fromMap(res.first).fillCategories() : null;
  }

  Future<int> remove() async {
    final db = await MoodDB.instance.database;
    return await db.delete("mood", where: 'id = ?', whereArgs: [id]);
  }

  Future<Mood> fillCategories() async {
    final db = await MoodDB.instance.database;
    final res =
        await db.query("categories", where: 'moodId = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      for (var element in res) {
        MoodCategory category = await MoodCategory.fromMap(element).fillIcons();
        categories.add(category);
      }
    }
    return this;
  }
}
