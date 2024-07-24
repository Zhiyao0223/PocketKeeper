import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/app_setting.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class AppSettingService extends ObjectboxService<AppSetting> {
  AppSettingService() : super(MemberCache.objectBox!.store, AppSetting);

  AppSetting initAppSetting() {
    List<AppSetting> appSettings = getAll();

    if (appSettings.isEmpty) {
      add(AppSetting());
      appSettings = getAll();
    }
    return appSettings.first;
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

  void restoreBackup(Map<String, dynamic> data) {
    if (data['app_setting'] == null) {
      return;
    }

    final List<AppSetting> expenses = data['app_setting']
        .map<AppSetting>((dynamic entity) => AppSetting.fromJson(entity))
        .toList();

    putMany(expenses);
  }
}
