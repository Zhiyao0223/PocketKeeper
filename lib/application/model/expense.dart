import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/enum/sync_status.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/user_service.dart';

@Entity()
class Expenses {
  int id = 0;

  late String description;
  late double amount;
  late int expensesType; // 0 - Expense, 1 - Income
  late int syncStatus; // sync, notSynced, none
  late int status;

  // Image
  @Property(type: PropertyType.byteVector)
  Uint8List? image;

  @Property(type: PropertyType.date)
  late DateTime expensesDate;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  // Database use
  final user = ToOne<Users>();
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

    setUsers();
  }

  void setUsers() {
    user.target = UserService().getLoginedUser();
  }

  void setCategory(Category tmpCategory) {
    category.target = tmpCategory;
  }

  void setAccount(Accounts tmpAccount) {
    account.target = tmpAccount;
  }

  Future<void> setImage(XFile tmpFile) async {
    image = await tmpFile.readAsBytes();
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'expensesType': expensesType,
      'syncStatus': syncStatus,
      'status': status,
      'image': image,
      'expensesDate': expensesDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }

  // From JSON
  Expenses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    amount = json['amount'];
    expensesType = json['expensesType'];
    syncStatus = json['syncStatus'];
    status = json['status'];
    image = json['image'];
    expensesDate = DateTime.parse(json['expensesDate']);
    createdDate = DateTime.parse(json['createdDate']);
    updatedDate = DateTime.parse(json['updatedDate']);
  }
}
