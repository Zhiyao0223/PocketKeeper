import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../template/state_management/controller.dart';

class SettingController extends FxController {
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;
    update();
  }

  void launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'zhiyao0223@gmail.com',
      query: 'subject=Queries about PocketKeeper App',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      showToast(customMessage: 'Could not launch email');
    }
  }

  // Handle logout
  Future<bool> onLogoutClick() async {
    // Clear share pref
    // await SharedPreferences.getInstance().then((prefs) {
    //   prefs.remove("user_id");
    // });

    // Clear objectbox
    UserService().deleteAll();

    // Reset cache
    MemberCache().reset();

    return true;
  }

  @override
  String getTag() {
    return "SettingController";
  }
}
