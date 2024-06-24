import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Expenses {
  @Id(assignable: true)
  late int expensesId;

  late String description;
  late double amount;
  late Category categoryId;
  late int syncStatus;
  late int status;
  late DateTime createdDate;
  late DateTime updatedDate;

  Expenses({
    int? tmpExpensesId,
    String? tmpDescription,
    double? tmpAmount,
    Category? tmpCategoryId,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    expensesId = tmpExpensesId ?? 0;
    description = tmpDescription ?? '';
    amount = tmpAmount ?? 0.0;
    categoryId = tmpCategoryId ?? Category();
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.none.index;
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
