import 'dart:ffi';

import 'package:ekimood/db/mood_database.dart';
import 'package:ekimood/model/mood_category.dart';
import 'package:flutter/material.dart';

class MoodIcons {
  static Icon sunny = MoodIcon._iconShelf[0];
  static Icon cloudy = MoodIcon._iconShelf[1];
  static Icon raining = MoodIcon._iconShelf[2];
}

class MoodIcon {
  static String tableName = "icon";
  static String idField = "id";
  static String iconField = "icon";
  static String selectedField = "selected";
  static String categoryIdField = "categoryId";

  MoodIcon(
      {this.id,
      required this.icon,
      this.selected = false,
      required this.category});

  int? id;
  bool selected;
  Icon icon;
  MoodCategory category;

  static final List<Icon> _iconShelf = [
    const Icon(Icons.sunny),
    const Icon(Icons.cloud),
    const Icon(Icons.cloudy_snowing)
  ];

  Map<String, dynamic> toMap() {
    return {
      iconField: icon.toString(),
      selectedField: selected ? 1 : 0,
      categoryIdField: category.id,
    };
  }

  static Future<MoodIcon> fromMap(Map<String, dynamic> map) async {
    MoodCategory? category =
        await MoodCategory.findCategoryById(map[categoryIdField] as int);
    return MoodIcon(
        icon: _iconShelf[map[iconField]],
        selected: map[selectedField] == "1" ? true : false,
        id: map[idField],
        category: category!);
  }

  save() async {
    // save the icon
    final db = await MoodDB.instance.database;
    final id = await db.insert(MoodIcon.tableName, toMap());
    return id;
  }
}
