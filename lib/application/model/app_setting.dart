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
  late String currencyIndicator;

  // Credential
  late bool isGoogleSignIn;

  // Budget Setting
  late double monthlyLimit;
  late int endOfMonth; // 1-30, 30 mean last day

  // Constructor
  AppSetting() {
    appName = "PocketKeeper";
    appVersion = "1.0.0";
    appTheme = AppTheme.lightTheme.name;
    appLanguage = Language.en.name;
    isGoogleSignIn = false;
    currencyIndicator = "\$";
    monthlyLimit = 5000;
    endOfMonth = 30;
  }
}
