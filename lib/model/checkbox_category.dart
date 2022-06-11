import 'package:ekimood/model/category_icon.dart';
import 'mood_category.dart';

class CheckboxCategory extends MoodCategory {
  CheckboxCategory({required super.name});

  @override
  void selectIcon(CategoryIcon selectIcon) {
    selectIcon.selected = !selectIcon.selected;
  }
}
