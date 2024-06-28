import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Expenses {
  int id = 0;

  late String description;
  late double amount;
  late int expensesType; // 0 - Expense, 1 - Income
  late int syncStatus; // sync, notSynced, none
  late int status;

  @Property(type: PropertyType.date)
  late DateTime expensesDate;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  // Database use
  final category = ToOne<Category>();
  final account = ToOne<Accounts>();

  Expenses({
    double? tmpAmount,
    DateTime? tmpExpensesDate,
    String? tmpDescription,
    int? tmpExpensesType,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    description = tmpDescription ?? '';
    amount = tmpAmount ?? 0.0;
    expensesDate = tmpExpensesDate ?? DateTime.now();
    expensesType = tmpExpensesType ?? 0;
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.notSynced.index;
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
