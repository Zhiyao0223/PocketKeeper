import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pocketkeeper/application/service/account_service.dart';
import 'package:pocketkeeper/application/service/app_setting_service.dart';
import 'package:pocketkeeper/application/service/expense_goal_service.dart';
import 'package:pocketkeeper/application/service/expense_limit_service.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/goal_saving_record_service.dart';
import 'package:pocketkeeper/application/service/google_drive_service.dart';
import 'package:pocketkeeper/application/service/notification_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/utils/custom_function.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

class BackupService {
  GoogleDriveService googleDriveService = GoogleDriveService();

  // Constructor
  BackupService();

  Future<bool> backupData({
    bool isExport = false,
  }) async {
    Map<String, List<Map<String, dynamic>>> data = {};

    // Expense
    List<Map<String, dynamic>> tmpData = ExpenseService().getBackup();

    // Add tmpdata to data
    data.addEntries([MapEntry("expense", tmpData)]);

    // Add additional data if is backup
    if (!isExport) {
      // Backup app setting
      tmpData = AppSettingService().getBackup();
      data.addEntries([MapEntry("app_setting", tmpData)]);

      // Backup accounts
      tmpData = AccountService().getBackup();
      data.addEntries([MapEntry("accounts", tmpData)]);

      // Expense Goal
      tmpData = ExpenseGoalService().getBackup();
      data.addEntries([MapEntry("expense_goal", tmpData)]);

      // Expense Limit
      tmpData = ExpenseLimitService().getBackup();
      data.addEntries([MapEntry("expense_limit", tmpData)]);

      // Goal Saving Record
      tmpData = GoalSavingRecordService().getBackup();
      data.addEntries([MapEntry("goal_saving_record", tmpData)]);

      // Notification
      tmpData = NotificationService().getBackup();
      data.addEntries([MapEntry("notification", tmpData)]);

      // User
      tmpData = UserService().getBackup();
      data.addEntries([MapEntry("user", tmpData)]);
    }

    return await _writeToFile(data: data, isExport: isExport);
  }

  Future<bool> _writeToFile({
    required Map<String, List<Map<String, dynamic>>> data,
    required bool isExport,
  }) async {
    bool status = false;

    // Export as CSV
    if (isExport) {
      status = await _downloadFile(
        tmpData: data,
      );
    }
    // Backup
    else {
      final directory = await getApplicationCacheDirectory();

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Backup
      const filename = 'pocketkeeper_backup.json';
      final file = File('${directory.path}/$filename');

      // Convert data to JSON
      String jsonData = convertListToJSON(data);

      // Write CSV data to the file
      await file.writeAsString(jsonData);

      // Open google drive
      await googleDriveService.uploadFile(file);

      status = true;
    }

    return status;
  }

  // Download file
  Future<bool> _downloadFile({
    required Map<String, List<Map<String, dynamic>>> tmpData,
  }) async {
    final directory = await getPublicDirectoryPath();

    // Backup
    const filename = 'pocketkeeper_backup.csv';
    final file = File('$directory/$filename');

    // Convert data to CSV string
    String csvData = convertListToCSV(tmpData);

    //Write CSV data to the file
    await file.writeAsString(csvData);

    log('Data exported to CSV file: ${file.path}');
    showToast(
      customMessage: "Data exported to CSV file: ${file.path}",
    );

    return true;
  }

  // Restore data
  Future<bool> restoreData() async {
    String responseJson = await googleDriveService.downloadFile() ?? "";

    if (responseJson.isEmpty) {
      return false;
    }

    // Convert JSON to Map
    Map<String, dynamic> jsonData = convertJSONToList(responseJson);

    // Breakdown data and add into respective tables
    ExpenseService().deleteAll();
    ExpenseService().restoreBackup(jsonData);

    AppSettingService().deleteAll();
    AppSettingService().restoreBackup(jsonData);

    AccountService().deleteAll();
    AccountService().restoreBackup(jsonData);

    ExpenseGoalService().deleteAll();
    ExpenseGoalService().restoreBackup(jsonData);

    ExpenseLimitService().deleteAll();
    ExpenseLimitService().restoreBackup(jsonData);

    GoalSavingRecordService().deleteAll();
    GoalSavingRecordService().restoreBackup(jsonData);

    NotificationService().deleteAll();
    NotificationService().restoreBackup(jsonData);

    UserService().deleteAll();
    UserService().restoreBackup(jsonData);

    return true;
  }

  // Resync data
  // TODO
  bool resyncData() {
    return true;
  }
}
