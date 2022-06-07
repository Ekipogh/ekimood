import 'package:ekimood/model/category_icons.dart';
import 'mood_category.dart';

class CheckboxCategory extends MoodCategory {
  CheckboxCategory({required super.name});

  @override
  void selectIcon(CategoryIcon selectIcon) {
    bool selection = icons[selectIcon]!;
    icons[selectIcon] = !selection;
  }
}
