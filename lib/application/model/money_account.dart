import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Accounts {
  @Id(assignable: true)
  int accountId = 0;

  late String accountName;
  late String accountType;
  late IconData accountIcon;

  // Constructor
  Accounts({
    this.accountId = 0,
    required this.accountName,
    required this.accountType,
    this.accountIcon = Icons.account_balance_wallet_outlined,
  });
}
