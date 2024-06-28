import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class SettingService extends ObjectboxService<AppSetting> {
  SettingService() : super(MemberCache.objectBox!.store, AppSetting);

  // Get app setting
  AppSetting getAppSetting() {
    final List<AppSetting> appSettings = getAll();

    if (appSettings.isEmpty) {
      final AppSetting appSetting = AppSetting();
      add(appSetting);
      return appSetting;
    } else {
      return appSettings.first;
    }
  }
}
