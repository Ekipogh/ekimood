import 'package:ekimood/model/category_icon.dart';

abstract class MoodCategory {
  MoodCategory({this.id, required this.name, this.moodId});

  int? id;
  String name;
  List<CategoryIcon> icons = [];
  int? moodId;

  void addIcon(CategoryIcon icon) {
    icons.add(icon);
  }

  void removeIcon(CategoryIcon icon) {
    icons.remove(icon);
  }

  void selectIcon(CategoryIcon selectIcon);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "icons": [for (var icon in icons) icon.toMap()]
    };
  }
}
