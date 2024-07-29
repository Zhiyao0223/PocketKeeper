import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/service/account_service.dart';
import 'package:pocketkeeper/application/service/api_service.dart';
import 'package:pocketkeeper/application/service/app_setting_service.dart';
import 'package:pocketkeeper/application/service/expense_goal_service.dart';
import 'package:pocketkeeper/application/service/expense_limit_service.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/goal_saving_record_service.dart';
import 'package:pocketkeeper/application/service/google_drive_service.dart';
import 'package:pocketkeeper/application/service/notification_service.dart';
import 'package:pocketkeeper/application/service/user_service.dart';
import 'package:pocketkeeper/utils/app_permission.dart';
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

    // Check if data is empty
    bool hasData = false;
    data.forEach((key, value) {
      if (value.isNotEmpty) {
        hasData = true;
      }
    });

    if (!hasData) {
      showToast(customMessage: "No data to ${isExport ? 'export' : 'backup'}");
    }

    return hasData ? await _writeToFile(data: data, isExport: isExport) : false;
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
      try {
        await AppPermission.requestStoragePermission();

        await file.writeAsString(jsonData);

        // Open google drive
        status = await googleDriveService.uploadFile(file);
      } catch (e) {
        log('Error: $e');
        showToast(
          customMessage: "Error writing to file. Please try again.",
        );
        return false;
      }
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

    try {
      await AppPermission.requestStoragePermission();

      //Write CSV data to the file
      await file.writeAsString(csvData);
    } catch (e) {
      log('Error: $e');
      showToast(
        customMessage: "Error writing to file. Please try again.",
      );
      return false;
    }
    // await file.writeAsString(csvData);

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
  Future<bool> resyncData() async {
    // Sync expenses first then profile
    bool status = await resyncExpenses();
    if (status) {
      status = await resyncProfile();
    }

    return status;
  }

  // Resync expenses
  Future<bool> resyncExpenses() async {
    try {
      // Get data from API
      const String filename = "get_unsync_data.php";
      Map<String, dynamic> requestBody = {
        "process": "get_unsync",
        "email": MemberCache.user!.email,
      };

      Map<String, dynamic> responseJson = await ApiService.post(
        filename: filename,
        body: requestBody,
      );

      // Store all blogs into cache
      ExpenseService expenseService = ExpenseService();
      if (responseJson["status"] == 200) {
        for (var expense in responseJson["body"]["expenses"]) {
          Expenses record = Expenses.fromServerJson(expense);

          if (record.expensesType == 0) {
            ExpenseCache.expenses.add(record);
          } else {
            ExpenseCache.incomes.add(record);
          }

          // Store into database
          expenseService.add(record);
        }
        log("Get unsync data successful!");
      }
    } catch (e) {
      log('Error: $e');
      showToast(
        customMessage: "Slow / No internet connection. Please try again.",
      );
      return false;
    }

    return true;
  }

  // No time, temporary no do
  // Resync profile
  Future<bool> resyncProfile() async {
    //   try {
    //     // Get data from API
    //     const String filename = "get_unsync_data.php";
    //     Map<String, dynamic> requestBody = {
    //       "process": "get_unsync",
    //       "email": MemberCache.user!.email,
    //     };

    //     Map<String, dynamic> responseJson = await ApiService.post(
    //       filename: filename,
    //       body: requestBody,
    //     );

    //     // Store all blogs into cache
    //     ExpenseService expenseService = ExpenseService();
    //     if (responseJson["status"] == 200) {
    //       for (var expense in responseJson["body"]["expenses"]) {
    //         Expenses record = Expenses.fromServerJson(expense);

    //         if (record.expensesType == 0) {
    //           ExpenseCache.expenses.add(record);
    //         } else {
    //           ExpenseCache.incomes.add(record);
    //         }

    //         // Store into database
    //         expenseService.add(record);
    //       }
    //       log("Get unsync data successful!");
    //     }
    //   } catch (e) {
    //     log('Error: $e');
    //     showToast(
    //       customMessage: "Slow / No internet connection. Please try again.",
    //     );
    //     return false;
    //   }

    return true;
  }
}
