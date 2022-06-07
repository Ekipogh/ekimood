import 'package:ekimood/model/category_icons.dart';

import 'mood_category.dart';

class RadioCategory extends MoodCategory {
  RadioCategory({required super.name});

  @override
  void selectIcon(CategoryIcon selectIcon) {
    for (CategoryIcon icon in icons.keys) {
      icons[icon] = false;
    }
    icons[selectIcon] = true;
  }
}
