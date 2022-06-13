import 'package:flutter/material.dart';

class CategoryIcon {
  CategoryIcon(
      {this.id, required this.icon, required this.selected, this.categoryId});

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

  static CategoryIcon fromMap(Map<String, dynamic> map) {
    return CategoryIcon(
        icon: _iconShelf[map["icons"]],
        selected: map["selected"] as bool,
        id: map["id"],
        categoryId: map["categoryId"]);
  }
}
