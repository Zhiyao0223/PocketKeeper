import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Accounts {
  @Id(assignable: true)
  int accountId = 0;

  late String accountName;
  late IconData accountIcon;

  late int status; // 0 - Active, 1 - Inactive
  late DateTime createdDate;
  late DateTime updatedDate;

  // Constructor
  Accounts({
    required this.accountName,
    this.accountIcon = Icons.account_balance_wallet_outlined,
    this.status = 0,
  }) {
    createdDate = DateTime.now();
    updatedDate = DateTime.now();
  }
}
