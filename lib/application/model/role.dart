import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';

@Entity()
class Role {
  int id = 2;
  late String name;

  // Constructor
  Role({
    int? tmpId,
    String? tmpName,
  }) {
    id = tmpId ?? 2;
    name = tmpName ?? "normal_user";
  }
}
