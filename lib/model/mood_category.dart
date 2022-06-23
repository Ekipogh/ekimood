import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_icon.dart';

class MoodCategory {
  static String tableName = "category";
  static var idField = "id";
  static var nameField = "name";

  MoodCategory(
      {this.id,
      required this.name,
      this.moodId,
      this.type = CategoryType.radio});

  int? id;
  String name;
  List<MoodIcon> icons = [];
  int? moodId;
  CategoryType type;

  void addIcon(MoodIcon icon) {
    icons.add(icon);
  }

  void removeIcon(MoodIcon icon) {
    icons.remove(icon);
  }

  selectIcon(MoodIcon selectIcon) {
    if (type == CategoryType.radio) {
      for (MoodIcon icon in icons) {
        icon.selected = false;
      }
    }
    selectIcon.selected = true;
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
        MoodIcon icon = MoodIcon.fromMap(element);
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
    MoodIcon sunny = MoodIcon(icon: MoodIcons.sunny);
    MoodIcon cloudy = MoodIcon(icon: MoodIcons.cloudy);
    MoodIcon raining = MoodIcon(icon: MoodIcons.raining);
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
  }
}
