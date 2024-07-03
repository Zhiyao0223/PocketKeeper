import 'package:app_settings/app_settings.dart';

class AppPermission {
  // Go to settings to enable permission
  static void goToSettings(AppSettingsType type) {
    AppSettings.openAppSettings(type: type);
  }
}
