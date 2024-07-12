import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class RoleService extends ObjectboxService<Role> {
  RoleService() : super(MemberCache.objectBox!.store, Role);
}
