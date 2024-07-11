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
  late String currencyCode;

  // Notification
  late bool isNotificationOn;

  // Credential
  late bool isGoogleSignIn;
  late bool isBiometricOn;

  // Budget Setting
  late double monthlyLimit;
  late int endOfMonth; // 1-30, 30 mean last day

  // Constructor
  AppSetting({
    String? tmpCurrencyIndicator,
    String? tmpCurrencyCode,
  }) {
    appName = "PocketKeeper";
    appVersion = "1.0.0";
    appTheme = AppTheme.lightTheme.name;
    appLanguage = Language.en.name;
    isGoogleSignIn = false;
    isNotificationOn = true;
    isBiometricOn = false;
    currencyIndicator = tmpCurrencyIndicator ?? "\$";
    currencyCode = tmpCurrencyCode ?? "USD";
    monthlyLimit = 5000;
    endOfMonth = 30;
  }
}
