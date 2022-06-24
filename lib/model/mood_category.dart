import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_icon.dart';

class MoodCategory {
  static List<MoodCategory> categoriesList = [];
  static String tableName = "category";
  static var idField = "id";
  static var nameField = "name";

  MoodCategory({
    this.id,
    required this.name,
    this.moodId,
  });

  int? id;
  String name;
  List<MoodIcon> icons = [];
  int? moodId;

  void addIcon(MoodIcon icon) {
    icons.add(icon);
  }

  void removeIcon(MoodIcon icon) {
    icons.remove(icon);
  }

  selectIcon(MoodIcon selectIcon) {
    selectIcon.selected = !selectIcon.selected;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "icons": [for (var icon in icons) icon.toMap()]
    };
  }

  static MoodCategory fromMap(Map<String, dynamic> map) {
    return MoodCategory(
        id: map["id"], name: map["name"], moodId: map["moodId"]);
  }

  void fillIcons() async {
    final db = await MoodDB.instance.database;
    final res =
        await db.query("icons", where: "categoryId = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      for (var element in res) {
        MoodIcon icon = await MoodIcon.fromMap(element);
        icons.add(icon);
      }
    }
  }

  save() async {
    final db = await MoodDB.instance.database;
    final id = await db.insert(MoodCategory.tableName, toMap());
    return id;
  }

  static void initDefaultCategories() {
    MoodCategory weather = MoodCategory(name: "Weather");
    MoodIcon sunny = MoodIcon(icon: MoodIcons.sunny, category: weather);
    MoodIcon cloudy = MoodIcon(icon: MoodIcons.cloudy, category: weather);
    MoodIcon raining = MoodIcon(icon: MoodIcons.raining, category: weather);
    weather.addIcon(sunny);
    weather.addIcon(cloudy);
    weather.addIcon(raining);
    sunny.save();
    cloudy.save();
    raining.save();
    weather.save();
  }

  MoodIcon? findIconById(int id) {
    for (var icon in icons) {
      if (icon.id == id) {
        return icon;
      }
    }
    return null;
  }

  static Future<MoodCategory?> findCategoryById(int categoryId) async {
    final db = await MoodDB().database;
    final res = await db
        .query(tableName, where: "$idField = ?", whereArgs: [categoryId]);
    return res.isNotEmpty ? MoodCategory.fromMap(res.first) : null;
  }
}
