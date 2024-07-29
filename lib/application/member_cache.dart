import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/app_setting_service.dart';
import 'package:pocketkeeper/application/service/local_notification_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/utils/custom_function.dart';

class MemberCache {
  static Users? user;

  static String? oauthAccessToken =
      "ya29.a0AXooCgvHzsqzYzLoXl_nbykdnyJ7bvecHGaltV--KnC4yK49NtSymtKnwslYZ8MCpzC1Myv_4kp8dRIOQl01HZAeTC-EmpZFizVuuUQ_bvp-CRucT580KqXFWfCqwBNkOJuJu5QdtaxWNqAi5yZH9XOzkxvtdITxsG7YaCgYKAeUSARASFQHGX2Mi6OzscmYD7NoR187UcK0rLA0171";

  static AppSetting? appSetting;

  // Local database
  static ObjectBox? objectBox;

  // Camera
  static List<CameraDescription> cameras = [];

  // Notification
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Tuned Model for Auto Categorizing
  static bool isTunedModelEnable = true;
  static bool isImageModelEnable = true;

  // This function is to initialize login
  static Future<void> initLogin() async {
    user = UserService().getLoginedUser();

    // Check profile picture
    if (user != null && user!.profilePicture == null) {
      user!.profilePicture = await loadAssetAsUint8List(
        "assets/images/user_placeholder.jpg",
      );
    }

    appSetting = AppSettingService().initAppSetting();
    LocalNotificationService().init();
  }

  // This function is to reset cache
  reset() {
    user = null;
    appSetting = AppSetting();
  }
}
