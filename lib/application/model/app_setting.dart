import 'package:objectbox/objectbox.dart';
import 'package:pocketkeeper/application/model/enum/app_theme.dart';
import 'package:pocketkeeper/application/model/enum/language.dart';

@Entity()
class AppSetting {
  @Id(assignable: true)
  int settingId = 0;

  late String appName;
  late String appVersion;
  late String appTheme;
  late String appLanguage;
  late String currencyCode;

  late bool isGoogleSignIn;

  // Constructor
  AppSetting() {
    appName = "PocketKeeper";
    appVersion = "1.0.0";
    appTheme = AppTheme.lightTheme.name;
    appLanguage = Language.en.name;
    isGoogleSignIn = false;
    currencyCode = "USD";
  }
}
