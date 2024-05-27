import 'package:pocketkeeper/application/model/role.dart';

class Users {
  late String id;
  late String name;
  late String email;
  late String password;
  late Role role;

  Users({
    String? tmpId,
    String? tmpName,
    String? tmpEmail,
    String? tmpPassword,
    Role? tmpRole,
  }) {
    id = tmpId ?? "";
    name = tmpName ?? "";
    email = tmpEmail ?? "";
    password = tmpPassword ?? "";
    role = tmpRole ?? Role();
  }

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    return data;
  }
}
