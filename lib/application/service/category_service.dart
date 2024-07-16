import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class CategoryService extends ObjectboxService<Category> {
  CategoryService() : super(MemberCache.objectBox!.store, Category);

  // Get expense categories
  List<Category> getExpenseCategories() {
    final List<Category> categories = getAll();
    return categories
        .where((Category category) =>
            category.categoryType == 0 && category.status == 0)
        .toList();
  }

  // Get income categories
  List<Category> getIncomeCategories() {
    final List<Category> categories = getAll();
    return categories
        .where((Category category) =>
            category.categoryType == 1 && category.status == 0)
        .toList();
  }

  // Get category by name
  Category? getCategoryByName(String name, [bool isExpenseCategory = true]) {
    final List<Category> categories = getAll();

    try {
      return categories.firstWhere((Category category) =>
          category.categoryName.toLowerCase() == name &&
          category.categoryType == (isExpenseCategory ? 0 : 1) &&
          category.status == 0);
    } catch (e) {
      return null;
    }
  }
}
