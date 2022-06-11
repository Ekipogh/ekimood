import 'package:flutter/material.dart';

class CategoryIcon {
  CategoryIcon(
      {this.id, required this.icon, required this.selected, this.categoryId});

  int? id;
  bool selected;
  Icon icon;
  int? categoryId;

  Map<String, dynamic> toMap() {
    return {"icon": icon.toString(), "selected": selected};
  }
}
