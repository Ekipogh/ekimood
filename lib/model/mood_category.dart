import 'package:ekimood/model/category_icons.dart';

abstract class MoodCategory {
  MoodCategory({required this.name});

  String name;
  Map<CategoryIcon, bool> icons = {};

  void addIcon(CategoryIcon icon) {
    icons[icon] = false;
  }

  void removeIcon(CategoryIcon icon) {
    icons.remove(icon);
  }

  void selectIcon(CategoryIcon selectIcon);
}
