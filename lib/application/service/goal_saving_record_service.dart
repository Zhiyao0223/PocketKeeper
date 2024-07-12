import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/goal_saving_record.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class GoalSavingRecordService extends ObjectboxService<GoalSavingRecord> {
  GoalSavingRecordService()
      : super(MemberCache.objectBox!.store, GoalSavingRecord);

  GoalSavingRecord getRecordsByGoalId(int tmpId) {
    return getAll().firstWhere((GoalSavingRecord record) => record.id == tmpId);
  }

  List<GoalSavingRecord> getAllActiveRecords() {
    final List<GoalSavingRecord> records = getAll();
    return records
        .where((GoalSavingRecord record) => record.status == 0)
        .toList();
  }

  Map<int, double> getLastContributionMonthAndTotal({required int month}) {
    final List<GoalSavingRecord> records = getAllActiveRecords();
    final Map<int, double> monthSaving = {};

    // If specific month
    final List<GoalSavingRecord> recordsInMonth = records
        .where((GoalSavingRecord record) => record.savingDate.month == month)
        .toList();

    if (recordsInMonth.isNotEmpty) {
      // Total saving in the month
      monthSaving[month] = recordsInMonth.fold<double>(
          0,
          (double previousValue, GoalSavingRecord element) =>
              previousValue + element.amount);

      return monthSaving;
    }

    return {month: 0};
  }

  List<GoalSavingRecord> getEachGoalLastContribution() {
    final List<GoalSavingRecord> records = getAllActiveRecords();

    // Sort by savingDate
    records.sort((GoalSavingRecord a, GoalSavingRecord b) =>
        b.savingDate.compareTo(a.savingDate));

    final Map<int, DateTime> lastContribution = {};

    for (final GoalSavingRecord record in records) {
      // Exist in list and date is earlier
      if (lastContribution.containsKey(record.goal.target!.goalId) &&
          lastContribution[record.id]!.isAfter(record.savingDate)) {
        continue;
      }

      lastContribution[record.goal.target!.goalId] = record.savingDate;
    }

    // Convert back to list
    List<GoalSavingRecord> lastContributionList = [];
    lastContribution.forEach((int key, DateTime value) {
      lastContributionList.add(records
          .firstWhere((GoalSavingRecord record) => record.savingDate == value));
    });

    return lastContributionList;
  }

  void restoreBackup(Map<String, dynamic> data) {
    if (data['goal_saving_record'] == null) {
      return;
    }

    final List<GoalSavingRecord> records = data['goal_saving_record']
        .map<GoalSavingRecord>(
            (dynamic entity) => GoalSavingRecord.fromJson(entity))
        .toList();

    putMany(records);
  }
}
