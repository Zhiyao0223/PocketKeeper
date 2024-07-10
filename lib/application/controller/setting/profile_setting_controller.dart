import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';

class ProfileSettingController extends FxController {
  bool isDataFetched = false;

  late Users currentUser;

  ProfileSettingController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    currentUser = MemberCache.user!;

    isDataFetched = true;
    update();
  }

  @override
  String getTag() {
    return "ProfileSettingController";
  }
}
