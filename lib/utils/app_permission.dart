import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  // Go to settings to enable permission
  static void goToSettings(AppSettingsType type) {
    AppSettings.openAppSettings(type: type);
  }

  // Check if permission is granted
  static Future<PermissionStatus> isPermissionGranted(
      Permission permissionType) async {
    return await permissionType.status;
  }

  static Future<bool> requestPermission(Permission permissionType) async {
    PermissionStatus status = await permissionType.status;

    if (status.isGranted) {
      return true;
    }

    status = await permissionType.request();

    if (status.isGranted) {
      return true;
    } else {
      openAppSettings();
    }

    return false;
  }
}
