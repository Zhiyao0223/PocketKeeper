import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class ExpenseService extends ObjectboxService<Expenses> {
  ExpenseService() : super(MemberCache.objectBox!.store, Expenses);

  // Get all expenses / income that are not deleted
  List<Expenses> getAllActiveRecords() {
    final List<Expenses> expenses = getAll();
    return expenses.where((Expenses expense) => expense.status == 0).toList();
  }

  List<Expenses> getAllActiveIncomes() {
    final List<Expenses> expenses = getAll();
    return expenses
        .where((Expenses expense) =>
            expense.status == 0 && expense.expensesType == 1)
        .toList();
  }

  List<Expenses> getAllActiveExpenses() {
    final List<Expenses> expenses = getAll();
    return expenses
        .where((Expenses expense) =>
            expense.status == 0 && expense.expensesType == 0)
        .toList();
  }

  List<Expenses> getExpensesByAccountId(int accountId) {
    final List<Expenses> expenses = getAll();
    return expenses
        .where((Expenses expense) =>
            expense.status == 0 && expense.account.target!.id == accountId)
        .toList();
  }

  // Get the top 1 expenses category in the month
  Map<Category, double> getTopSpendCategory(int month) {
    final List<Expenses> expenses = getAllActiveExpenses();
    final Map<Category, double> categoryMap = <Category, double>{};

    for (final Expenses expense in expenses) {
      // Only consider expenses in the same month
      if (expense.expensesDate.month != month) {
        continue;
      }

      final Category category = expense.category.target!;
      if (categoryMap.containsKey(category)) {
        categoryMap[category] = categoryMap[category]! + expense.amount;
      } else {
        categoryMap[category] = expense.amount;
      }
    }

    final List<MapEntry<Category, double>> sortedEntries = categoryMap.entries
        .toList()
      ..sort((MapEntry<Category, double> a, MapEntry<Category, double> b) =>
          b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries.take(1));
  }
}
