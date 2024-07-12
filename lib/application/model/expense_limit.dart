import 'package:objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';

@Entity()
class ExpenseLimit {
  int id = 0;

  late double amount;
  late int syncStatus;
  late int status;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  final category = ToOne<Category>();

  ExpenseLimit({
    double? tmpAmount,
    SyncStatus? tmpSyncStatus,
    int? tmpStatus,
    DateTime? tmpCreatedDate,
    DateTime? tmpUpdatedDate,
  }) {
    amount = tmpAmount ?? 0.0;
    syncStatus = tmpSyncStatus?.index ?? SyncStatus.none.index;
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate ?? DateTime.now();
    updatedDate = tmpUpdatedDate ?? DateTime.now();
  }

  void setCategory(Category tmpCategory) {
    category.target = tmpCategory;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'syncStatus': syncStatus,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }

  // From JSON
  ExpenseLimit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    syncStatus = json['syncStatus'];
    status = json['status'];
    createdDate = DateTime.parse(json['createdDate']);
    updatedDate = DateTime.parse(json['updatedDate']);
  }
}
