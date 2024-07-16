import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/app_setting_service.dart';
import 'package:pocketkeeper/application/service/local_notification_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/utils/custom_function.dart';

class MemberCache {
  static Users? user;

  static Role role = Role();

  static String? oauthAccessToken =
      "ya29.a0AXooCgt1PQotHM4kOzdg1tOq4BRxnFkYeiJVgKyk45KU2aGtD6cFXIkIh5EKLKmj70E2GPQZPcVols1GvAXvKJFKsRvOD0UqqootuAi-5JTIUV8yxzj6Zxf79521qdWh0bUGwW8oiFXS3xRE0qHs5tem_AtXnY323EA4aCgYKAf8SARASFQHGX2MiMnS_5Ap179nCE0NC4TqqyA0171";

  static AppSetting appSetting = AppSetting();

  // Local database
  static ObjectBox? objectBox;

  // Camera
  static List<CameraDescription> cameras = [];

  // Notification
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // This function is to initialize login
  static Future<void> initLogin() async {
    user = UserService().getLoginedUser();

    // Check profile picture
    if (user != null && user!.profilePicture == null) {
      user!.profilePicture = await loadAssetAsUint8List(
        "assets/images/user_placeholder.jpg",
      );
    }

    AppSettingService().initAppSetting();
    LocalNotificationService().init();
  }

  // This function is to reset cache
  reset() {
    user = null;
    appSetting = AppSetting();
  }
}
