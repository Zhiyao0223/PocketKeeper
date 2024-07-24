import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.g.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/utils/converters/string.dart';

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
    profilePicture = await image.readAsBytes();
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
      'profilePicture':
          profilePicture != null ? base64Encode(profilePicture!) : null,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }

  // From JSON
  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    discordId = json['discordId'];
    status = json['status'];
    profilePicture = json['profilePicture'] != null
        ? base64Decode(json['profilePicture'])
        : null;
    createdDate = DateTime.parse(json['createdDate']);
    updatedDate = DateTime.parse(json['updatedDate']);
  }
}
