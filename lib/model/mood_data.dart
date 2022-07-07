import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_category.dart';

import 'mood.dart';
import 'mood_icon.dart';

class MoodData {
  static String tableName = "data";
  static String moodIdField = "moodId";
  static String categoryIdField = "categoryId";
  static String iconIdField = "iconId";
  static String selectedField = "selected";
  static String idField = "id";

  MoodData({required this.category, required this.mood}) {
    map = {};
    for (MoodIcon icon in category.icons) {
      map[icon.id!] = false;
    }
  }

  final MoodCategory category;
  final Mood mood;
  late Map<int, bool> map;

  save() async {
    final db = await MoodDB().database;
    for (var data in map.entries) {
      await db.insert(tableName, {
        moodIdField: mood.id,
        categoryIdField: category.id,
        iconIdField: data.key,
        selectedField: data.value
      });
    }
  }

  void set(int iconId, bool selected) {
    map[iconId] = selected;
  }

  bool getSelected(MoodIcon icon) {
    return map[icon.id]!;
  }

  void select(MoodIcon icon) {
    map[icon.id!] = !map[icon.id]!;
  }
}
