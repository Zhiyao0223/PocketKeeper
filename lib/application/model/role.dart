class Role {
  late String id;
  late String name;

  // Constructor
  Role({String? tmpId, String? tmpName}) {
    id = tmpId ?? "2";
    name = tmpName ?? "normal_user";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
