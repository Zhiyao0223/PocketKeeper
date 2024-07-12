import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class AppSettingService extends ObjectboxService<AppSetting> {
  AppSettingService() : super(MemberCache.objectBox!.store, AppSetting);

  void initAppSetting() {
    final List<AppSetting> appSettings = getAll();

    if (appSettings.isEmpty) {
      add(AppSetting());
    }
  }

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
