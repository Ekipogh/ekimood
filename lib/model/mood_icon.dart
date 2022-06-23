import 'package:ekimood/db/mood_database.dart';
import 'package:flutter/material.dart';

class MoodIcons {
  static Icon sunny = MoodIcon._iconShelf[0];
  static Icon cloudy = MoodIcon._iconShelf[1];
  static Icon raining = MoodIcon._iconShelf[2];
}

class MoodIcon {
  static String tableName = "category";
  static String idField = "id";
  static String iconField = "icon";
  static String categoryIdField = "categoryId";

  MoodIcon(
      {this.id, required this.icon, this.selected = false, this.categoryId});

  int? id;
  bool selected;
  Icon icon;
  int? categoryId;

  static final List<Icon> _iconShelf = [
    const Icon(Icons.sunny),
    const Icon(Icons.cloud),
    const Icon(Icons.cloudy_snowing)
  ];

  Map<String, dynamic> toMap() {
    return {"icon": icon.toString(), "selected": selected};
  }

  static MoodIcon fromMap(Map<String, dynamic> map) {
    return MoodIcon(
        icon: _iconShelf[map["icons"]],
        selected: map["selected"] as bool,
        id: map["id"],
        categoryId: map["categoryId"]);
  }

  save() async {
    // save the icon
    final db = await MoodDB.instance.database;
    final id = await db.insert(MoodIcon.tableName, toMap());
    return id;
  }
}
