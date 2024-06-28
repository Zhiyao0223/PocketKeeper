import 'package:objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';

@Entity()
class ExpenseGoal {
  @Id(assignable: true)
  int goalId = 0;

  late String description;
  late int syncStatus;
  late int status;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  ExpenseGoal({
    String? tmpDescription,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    description = tmpDescription ?? '';
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.none.index;
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
