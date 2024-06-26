import 'package:pocketkeeper/application/member_constant.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class CategoryService extends ObjectboxService<Category> {
  CategoryService() : super(MemberConstant.objectBox!.store, Category);

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
}
