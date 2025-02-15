import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense_limit.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class ExpenseLimitService extends ObjectboxService<ExpenseLimit> {
  ExpenseLimitService() : super(MemberCache.objectBox!.store, ExpenseLimit);

  List<ExpenseLimit> getAllActiveExpenseLimits() {
    final List<ExpenseLimit> limits = getAll();
    return limits.where((ExpenseLimit limit) => limit.status == 0).toList();
  }

  Map<int, Map<double, double>> getCategoryLimitsAndBalance() {
    final ExpenseService expenseService = ExpenseService();
    final List<ExpenseLimit> limits = getAll();
    final Map<int, Map<double, double>> categoryLimitsAndBalance = {};

    // Ge total spent for all categories
    Map<Category, double> categoryExpenses =
        expenseService.getTotalExpensesByCategory(DateTime.now().month);

    for (final ExpenseLimit limit in limits) {
      final categoryIndex = categoryExpenses.keys.toList().indexWhere(
          (Category category) =>
              category.categoryName == limit.category.target!.categoryName);

      final double totalSpent = categoryIndex != -1
          ? categoryExpenses.values.toList()[categoryIndex]
          : 0;

      categoryLimitsAndBalance[limit.category.target!.id] = {
        limit.amount: limit.amount - totalSpent,
      };
    }

    return categoryLimitsAndBalance;
  }

  void restoreBackup(Map<String, dynamic> data) {
    if (data['expense_limit'] == null) {
      return;
    }

    final List<ExpenseLimit> expenses = data['expense_limit']
        .map<ExpenseLimit>((dynamic entity) => ExpenseLimit.fromJson(entity))
        .toList();

    putMany(expenses);
  }
}
