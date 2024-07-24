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

  // Backup
  @Property(type: PropertyType.date)
  late DateTime? lastBackupDate;

  @Property(type: PropertyType.date)
  late DateTime? lastRestoreDate;

  @Property(type: PropertyType.date)
  late DateTime? lastResyncDate;

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
    lastBackupDate = null;
    lastRestoreDate = null;
    lastResyncDate = null;
    monthlyLimit = 3000;
    endOfMonth = 30;
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'settingId': settingId,
      'appName': appName,
      'appVersion': appVersion,
      'appTheme': appTheme,
      'appLanguage': appLanguage,
      'currencyIndicator': currencyIndicator,
      'currencyCode': currencyCode,
      'isNotificationOn': isNotificationOn,
      'isGoogleSignIn': isGoogleSignIn,
      'isBiometricOn': isBiometricOn,
      'lastResyncDate': lastResyncDate?.toIso8601String(),
      'lastBackupDate': lastBackupDate?.toIso8601String(),
      'lastRestoreDate': lastRestoreDate?.toIso8601String(),
      'monthlyLimit': monthlyLimit,
      'endOfMonth': endOfMonth,
    };
  }

  // From JSON
  AppSetting.fromJson(Map<String, dynamic> json) {
    settingId = json['settingId'];
    appName = json['appName'];
    appVersion = json['appVersion'];
    appTheme = json['appTheme'];
    appLanguage = json['appLanguage'];
    currencyIndicator = json['currencyIndicator'];
    currencyCode = json['currencyCode'];
    isNotificationOn = json['isNotificationOn'];
    isGoogleSignIn = json['isGoogleSignIn'];
    isBiometricOn = json['isBiometricOn'];
    lastBackupDate = json['lastBackupDate'] != null
        ? DateTime.parse(json['lastBackupDate'])
        : null;
    lastRestoreDate = json['lastRestoreDate'] != null
        ? DateTime.parse(json['lastRestoreDate'])
        : null;
    lastResyncDate = json['lastResyncDate'] != null
        ? DateTime.parse(json['lastResyncDate'])
        : null;
    monthlyLimit = json['monthlyLimit'];
    endOfMonth = json['endOfMonth'];
  }
}
