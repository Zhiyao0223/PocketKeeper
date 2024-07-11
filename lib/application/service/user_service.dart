import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class UserService extends ObjectboxService<Users> {
  UserService() : super(MemberCache.objectBox!.store, Users);

  // Get logined user
  Users? getLoginedUser() {
    final List<Users> users = getAll();

    return (users.isNotEmpty) ? users.first : null;
  }

  // Update logined user
  void updateLoginUser(Users user) {
    final List<Users> users = getAll();

    if (users.isNotEmpty) {
      user.id = users.first.id;
    }

    put(user);
  }
}
