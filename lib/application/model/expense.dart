import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Expenses {
  @Id(assignable: true)
  int expensesId = 0;

  late String description;
  late double amount;
  late Category category;
  late Accounts account;
  late int expensesType; // 0 - Expense, 1 - Income
  late int syncStatus; // sync, notSynced, none
  late int status;
  late DateTime expensesDate;
  late DateTime createdDate;
  late DateTime updatedDate;

  Expenses({
    double? tmpAmount,
    Category? tmpCategory,
    DateTime? tmpExpensesDate,
    Accounts? tmpAccount,
    String? tmpDescription,
    int? tmpExpensesType,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    description = tmpDescription ?? '';
    amount = tmpAmount ?? 0.0;
    category = tmpCategory ?? Category();
    account = tmpAccount ?? Accounts(accountName: '');
    expensesDate = tmpExpensesDate ?? DateTime.now();
    expensesType = tmpExpensesType ?? 0;
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.notSynced.index;
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
