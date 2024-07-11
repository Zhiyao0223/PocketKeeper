import 'package:camera/camera.dart';
import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/app_setting_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';

class MemberCache {
  static Users? user;

  static Role role = Role();

  static String? oauthAccessToken =
      "ya29.a0AXooCgt63AUDMkk6NyDkxkMafKXgv4sMU79yarJDqcDaJGjqMPxqIEc_CQPmK7cVEvfs0FLn4TC-rIj6lteAMme-Iymb0mtHY3p4X9_TlkJeehIsU7iA00U74Dvpv7uOVLneZl0aY9D2Wdt5Wryb6IxjuDKM3wtE8cVZaCgYKAY0SARASFQHGX2MiuM9cWCrnQ_fR-gileXNsVg0171";

  static AppSetting appSetting = AppSetting();

  // Local database
  static ObjectBox? objectBox;

  // Camera
  static List<CameraDescription> cameras = [];

  // This function is to initialize login
  static void initLogin() {
    user = UserService().getLoginedUser();
    AppSettingService().initAppSetting();
  }

  // This function is to reset cache
  reset() {
    user = null;
    appSetting = AppSetting();
  }
}
