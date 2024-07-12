import 'package:flutter/widgets.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/user.dart';
import 'package:pocketkeeper/application/service/backup_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';
import 'package:pocketkeeper/utils/converters/date.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

class BackupRestoreController extends FxController {
  bool isDataFetched = false;

  late DateTime? lastBackupDate;
  late DateTime? lastRestoreDate;

  BackupService backupService = BackupService();

  // Constructor
  BackupRestoreController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    lastBackupDate = MemberCache.appSetting.lastBackupDate;
    lastRestoreDate = MemberCache.appSetting.lastRestoreDate;

    isDataFetched = true;
    update();
  }

  String? getLastBackupDate() {
    return lastBackupDate != null
        ? "Last backup: ${lastBackupDate!.toDateString(dateFormat: "d MMM yyyy")}"
        : null;
  }

  String? getLastRestoreDate() {
    return lastRestoreDate != null
        ? "Last restore: ${lastRestoreDate!.toDateString(dateFormat: "d MMM yyyy")}"
        : null;
  }

  Future<void> backupData() async {
    bool backupStatus = await backupService.backupData().then((value) {
      Navigator.pop(context);
      return value;
    });

    showToast(
      customMessage: backupStatus ? "Backup successful" : "Backup failed",
    );

    // Set current date
    lastBackupDate = DateTime.now();
    MemberCache.appSetting.lastBackupDate = lastBackupDate;

    // Update user
    Users user = MemberCache.user!;
    UserService().updateLoginUser(user);

    update();
  }

  Future<void> restoreData() async {
    bool restoreStatus = await backupService.restoreData().then((value) {
      Navigator.pop(context);
      return value;
    });

    showToast(
      customMessage: restoreStatus ? "Restore successful" : "Restore failed",
    );

    // Set current date
    lastRestoreDate = DateTime.now();
    MemberCache.appSetting.lastRestoreDate = lastRestoreDate;

    // Update user
    Users user = MemberCache.user!;
    UserService().updateLoginUser(user);

    update();
  }

  void exportData() {
    // Export data
    backupService.backupData(isExport: true);
    Navigator.pop(context);
  }

  @override
  String getTag() {
    return "CurrencyConversionController";
  }
}
