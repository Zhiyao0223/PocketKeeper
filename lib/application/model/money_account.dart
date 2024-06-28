import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Accounts {
  int id = 0;

  late String accountName;
  late int accountIconHex;

  late int status; // 0 - Active, 1 - Inactive

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  // Constructor
  Accounts({
    int? tmpId,
    required this.accountName,
    int? tmpAccountIconHex,
    this.status = 0,
  }) {
    id = tmpId ?? 0;
    accountIconHex = tmpAccountIconHex ?? 0;
    createdDate = DateTime.now();
    updatedDate = DateTime.now();
  }
}
