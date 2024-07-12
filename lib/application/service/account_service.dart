import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class AccountService extends ObjectboxService<Accounts> {
  AccountService() : super(MemberCache.objectBox!.store, Accounts);

  List<Accounts> getAllActiveAccounts() {
    final List<Accounts> accounts = getAll();
    return accounts.where((Accounts account) => account.status == 0).toList();
  }

  bool isAccountNameExist(String name) {
    final List<Accounts> accounts = getAll();
    return accounts.any((Accounts account) => account.accountName == name);
  }

  bool isAnyRecordLinkedToAccount(int accountId) {
    List<Expenses> expenses = ExpenseService().getAllActiveRecords();
    return expenses
        .any((Expenses expense) => expense.account.target!.id == accountId);
  }

  void restoreBackup(Map<String, dynamic> data) {
    if (data['accounts'] == null) {
      return;
    }

    final List<Accounts> expenses = data['accounts']
        .map<Accounts>((dynamic entity) => Accounts.fromJson(entity))
        .toList();

    putMany(expenses);
  }
}
