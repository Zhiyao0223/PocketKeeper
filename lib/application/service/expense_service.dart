import 'package:pocketkeeper/application/member_constant.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class ExpenseService extends ObjectboxService<Expenses> {
  ExpenseService() : super(MemberConstant.objectBox!.store, Expenses);

  // Get all expenses / income that are not deleted
  List<Expenses> getExpenses() {
    final List<Expenses> expenses = getAll();
    return expenses.where((Expenses expense) => expense.status == 0).toList();
  }
}
