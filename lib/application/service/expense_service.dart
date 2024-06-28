import 'package:pocketkeeper/application/member_cache.dart';
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
}
