import 'package:objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';

@Entity()
class ExpenseLimit {
  @Id(assignable: true)
  int limitId = 0;

  late Category categoryId;
  late double amount;
  late int syncStatus;
  late int status;
  late DateTime createdDate;
  late DateTime updatedDate;

  ExpenseLimit({
    Category? tmpCategoryId,
    double? tmpAmount,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    categoryId = tmpCategoryId ?? Category();
    amount = tmpAmount ?? 0.0;
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.none.index;
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
