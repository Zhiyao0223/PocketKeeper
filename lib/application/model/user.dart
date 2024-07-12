import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/utils/converters/string.dart';
import 'package:pocketkeeper/utils/converters/image.dart';

@Entity()
class Users {
  int id = 0;

  late String name;
  late String email;
  late String password;

  late int status;
  late String discordId;

  // Image
  @Property(type: PropertyType.byteVector)
  Uint8List? profilePicture;

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
    String? tmpDiscordId,
    int? tmpStatus,
    String? tmpCreatedDate,
    String? tmpUpdatedDate,
  }) {
    id = tmpId ?? 0;
    name = tmpName ?? "";
    email = tmpEmail ?? "";
    password = tmpPassword ?? "";
    discordId = tmpDiscordId ?? "";
    status = tmpStatus ?? 0;
    createdDate = tmpCreatedDate?.toDateTime() ?? DateTime.now();
    updatedDate = tmpUpdatedDate?.toDateTime() ?? DateTime.now();
  }

  void setImage(XFile image) async {
    profilePicture = await image.getBytesFromImage();
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'discordId': discordId,
      'status': status,
      'profilePicture': profilePicture,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }
}
