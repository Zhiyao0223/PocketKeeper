import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/utils/converters/string.dart';

@Entity()
class Users {
  @Id(assignable: true)
  late int userId;

  late String name;
  late String email;
  late String password;
  late String profilePictureUrl;

  late int status;
  late Role role;
  late String discordId;
  late DateTime createdDate;
  late DateTime updatedDate;

  Users({
    String? tmpName,
    String? tmpEmail,
    String? tmpPassword,
    String? tmpProfilePictureUrl,
    Role? tmpRole,
    int? tmpStatus,
    String? tmpCreatedDate,
    String? tmpUpdatedDate,
  }) {
    name = tmpName ?? "";
    email = tmpEmail ?? "";
    password = tmpPassword ?? "";
    profilePictureUrl = tmpProfilePictureUrl ?? "user_placeholder.jpg";

    status = tmpStatus ?? 0;
    role = tmpRole ?? Role();
    createdDate = tmpCreatedDate?.toDateTime() ?? DateTime.now();
    updatedDate = tmpUpdatedDate?.toDateTime() ?? DateTime.now();
  }
}
