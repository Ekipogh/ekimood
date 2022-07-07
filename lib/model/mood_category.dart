import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_icon.dart';

class MoodCategory {
  static List<MoodCategory> categoriesList = [];
  static String tableName = "category";
  static String idField = "id";
  static String nameField = "name";

  MoodCategory({
    this.id,
    required this.name,
  }) {
    addToCategoryList(this);
    fillIcons();
  }

  late int? id;
  final String name;
  late List<MoodIcon> icons = [];

  Map<String, dynamic> toMap() {
    return {
      idField: id,
      nameField: name,
    };
  }

  static MoodCategory fromMap(Map<String, dynamic> map) {
    return MoodCategory(id: map[idField], name: map[nameField]);
  }

  void fillIcons() {
    for (var icon in MoodIcon.iconList) {
      if (icon.category == this) {
        icons.add(icon);
      }
    }
  }

  save() async {
    final db = await MoodDB.instance.database;
    final id = await db.insert(MoodCategory.tableName, toMap());
    this.id = id;
    return id;
  }

  static Future<void> initDefaultCategories() async {
    MoodCategory weather = MoodCategory(name: "Weather");
    await weather.save();
    MoodIcon sunny = MoodIcon(icon: MoodIcons.sunny, category: weather);
    MoodIcon cloudy = MoodIcon(icon: MoodIcons.cloudy, category: weather);
    MoodIcon raining = MoodIcon(icon: MoodIcons.raining, category: weather);
    await sunny.save();
    await cloudy.save();
    await raining.save();
    weather.fillIcons();
  }

  MoodIcon? findIconById(int id) {
    for (var icon in icons) {
      if (icon.id == id) {
        return icon;
      }
    }
    return null;
  }

  static MoodCategory? findCategoryById(int categoryId) {
    for (var category in categoriesList) {
      if (category.id == categoryId) {
        return category;
      }
    }
    return null;
  }

  static loadCategories() async {
    categoriesList = [];
    final db = await MoodDB().database;
    final res = await db.query(tableName);
    for (var row in res) {
      MoodCategory category = MoodCategory.fromMap(row);
      addToCategoryList(category);
    }
  }

  static void addToCategoryList(MoodCategory moodCategory) {
    if (!categoriesList.contains(moodCategory)) {
      categoriesList.add(moodCategory);
    }
  }

  static void fillAllIcons() {
    for (var category in categoriesList) {
      category.fillIcons();
    }
  }
}
