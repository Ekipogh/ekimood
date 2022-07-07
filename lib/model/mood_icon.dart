import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_category.dart';
import 'package:flutter/material.dart';

class MoodIcons {
  static final List<Icon> _iconShelf = [
    const Icon(Icons.sunny),
    const Icon(Icons.cloud),
    const Icon(Icons.cloudy_snowing)
  ];
  static Icon sunny = _iconShelf[0];
  static Icon cloudy = _iconShelf[1];
  static Icon raining = _iconShelf[2];

  static Icon get(int index) {
    return _iconShelf[index];
  }

  static int getIndex(Icon icon) {
    for (var index = 0; index < _iconShelf.length; index++) {
      if (_iconShelf[index] == icon) {
        return index;
      }
    }
    return -1;
  }
}

class MoodIcon {
  static String tableName = "icon";
  static String idField = "id";
  static String iconField = "icon";
  static String categoryIdField = "categoryId";
  static List<MoodIcon> iconList = [];

  MoodIcon({this.id, required this.icon, required this.category}) {
    addToIconsList(this);
  }

  int? id;
  Icon icon;
  MoodCategory category;

  Map<String, dynamic> toMap() {
    return {
      iconField: MoodIcons.getIndex(icon),
      categoryIdField: category.id,
    };
  }

  static MoodIcon fromMap(Map<String, dynamic> map) {
    MoodCategory? category = MoodCategory.findCategoryById(map["categoryId"]);
    return MoodIcon(
        icon: MoodIcons.get(map[iconField]),
        id: map[idField],
        category: category!);
  }

  save() async {
    // save the icon
    final db = await MoodDB.instance.database;
    final id = await db.insert(MoodIcon.tableName, toMap());
    this.id = id;
    return id;
  }

  static loadIcons() async {
    final db = await MoodDB().database;
    final res = await db.query(tableName);
    for (var row in res) {
      iconList.add(MoodIcon.fromMap(row));
    }
    MoodCategory.fillAllIcons();
  }

  static void addToIconsList(MoodIcon icon) {
    if (!iconList.contains(icon)) {
      iconList.add(icon);
    }
  }
}
