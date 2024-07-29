import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

class AppPermission {
  // Initialize (First time)
  static Future<void> init() async {
    await Permission.camera.request();
    await Permission.notification.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

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

  static Future<bool> requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    PermissionStatus statuses =
        await Permission.manageExternalStorage.request();

    if (statuses == PermissionStatus.denied) {
      showToast(
        customMessage: "App may malfunction without granted permissions",
      );
    }
    return statuses == PermissionStatus.granted;
  }
}
