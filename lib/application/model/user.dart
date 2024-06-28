import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/utils/converters/string.dart';

@Entity()
class Users {
  int id = 0;

  late String name;
  late String email;
  late String password;
  late String profilePictureUrl;

  late int status;
  late String discordId;

  @Property(type: PropertyType.date)
  late DateTime createdDate;

  @Property(type: PropertyType.date)
  late DateTime updatedDate;

  final role = ToOne<Role>();

  Users({
    int? tmpId,
    String? tmpName,
    String? tmpEmail,
    String? tmpPassword,
    String? tmpProfilePictureUrl,
    int? tmpStatus,
    String? tmpCreatedDate,
    String? tmpUpdatedDate,
  }) {
    id = tmpId ?? 0;
    name = tmpName ?? "";
    email = tmpEmail ?? "";
    password = tmpPassword ?? "";
    profilePictureUrl = tmpProfilePictureUrl ?? "user_placeholder.jpg";
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate?.toDateTime() ?? DateTime.now();
    updatedDate = tmpUpdatedDate?.toDateTime() ?? DateTime.now();
  }
}
