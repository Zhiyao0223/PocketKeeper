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

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'goalId': goalId,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'suggestedAmount': suggestedAmount,
      'syncStatus': syncStatus,
      'status': status,
      'iconHex': iconHex,
      'dueDate': dueDate?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }

  // From JSON
  ExpenseGoal.fromJson(Map<String, dynamic> json) {
    goalId = json['goalId'];
    description = json['description'];
    targetAmount = json['targetAmount'];
    currentAmount = json['currentAmount'];
    suggestedAmount = json['suggestedAmount'];
    syncStatus = json['syncStatus'];
    status = json['status'];
    iconHex = json['iconHex'];
    dueDate = json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null;
    createdDate = DateTime.parse(json['createdDate']);
    updatedDate = DateTime.parse(json['updatedDate']);
  }
}
