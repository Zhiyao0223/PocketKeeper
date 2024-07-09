import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';

@Entity()
class ExpenseGoal {
  @Id(assignable: true)
  int goalId = 0;

  late String description;

  late double targetAmount;
  late double currentAmount;
  late double suggestedAmount;

  late int syncStatus;
  late int status;
  late int iconHex;

  @Property(type: PropertyType.date)
  DateTime? dueDate;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  ExpenseGoal({
    String? tmpDescription,
    double? tmpCurrentAmount,
    double? tmpTargetAmount,
    double? tmpSuggestedAmount,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus, // 0 - active, 1 - completed, 2 - failed
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
    int? tmpIconHex,
    this.dueDate,
  }) {
    description = tmpDescription ?? '';
    currentAmount = tmpCurrentAmount ?? 0;
    targetAmount = tmpTargetAmount ?? 0;
    suggestedAmount = tmpSuggestedAmount ?? 0;
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.none.index;
    status = tmpStatus ?? 0;
    iconHex = tmpIconHex ?? Icons.account_balance.codePoint;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }
}
