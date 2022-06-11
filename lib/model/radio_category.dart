import 'package:ekimood/model/category_icon.dart';

import 'mood_category.dart';

class RadioCategory extends MoodCategory {
  RadioCategory({required super.name});

  @override
  void selectIcon(CategoryIcon selectIcon) {
    for (CategoryIcon icon in icons) {
      icon.selected = false;
    }
    selectIcon.selected = true;
  }
}
