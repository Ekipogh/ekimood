import 'package:ekimood/model/category_icon.dart';

enum CategoryType {
  radio(0),
  checkbox(1);

  const CategoryType(this.type);

  final num type;
}

class MoodCategory {
  MoodCategory(
      {this.id,
      required this.name,
      this.moodId,
      this.type = CategoryType.radio});

  int? id;
  String name;
  List<CategoryIcon> icons = [];
  int? moodId;
  CategoryType type;

  void addIcon(CategoryIcon icon) {
    icons.add(icon);
  }

  void removeIcon(CategoryIcon icon) {
    icons.remove(icon);
  }

  selectIcon(CategoryIcon selectIcon) {
    if (type == CategoryType.radio) {
      for (CategoryIcon icon in icons) {
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
}
