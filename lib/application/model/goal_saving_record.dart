import 'package:pocketkeeper/application/model/enum/sync_status.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class GoalSavingRecord {
  int id = 0;

  late double amount;
  late int syncStatus; // sync, notSynced, none
  late int status;

  @Property(type: PropertyType.date)
  late DateTime savingDate;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  // Database use
  final goal = ToOne<ExpenseGoal>();

  GoalSavingRecord({
    double? tmpAmount,
    DateTime? tmpSavingDate,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    amount = tmpAmount ?? 0.0;
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.notSynced.index;
    savingDate = tmpSavingDate ?? DateTime.now();
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }

  void setGoal(ExpenseGoal tmpGoal) {
    goal.target = tmpGoal;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'syncStatus': syncStatus,
      'status': status,
      'savingDate': savingDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }

  // From JSON
  GoalSavingRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    syncStatus = json['syncStatus'];
    status = json['status'];
    savingDate = DateTime.parse(json['savingDate']);
    createdDate = DateTime.parse(json['createdDate']);
    updatedDate = DateTime.parse(json['updatedDate']);
  }
}
