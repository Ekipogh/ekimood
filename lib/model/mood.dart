import 'package:ekimood/db/mood_database.dart';
import 'package:equatable/equatable.dart';

class Mood extends Equatable {
  const Mood({this.id, required this.date, required this.rating});

  final int? id;
  final DateTime date;
  final int rating;

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
    final id = await db.insert("mood", toMap());
    return id;
  }

  static Future<Mood?> findByDate(DateTime date) async {
    final db = await MoodDB.instance.database;
    final res = await db
        .query("mood", where: 'date = ?', whereArgs: [date.toIso8601String()]);
    return res.isNotEmpty ? Mood.fromMap(res.first) : null;
  }

  @override
  List<Object?> get props => [id, date, rating];
}
