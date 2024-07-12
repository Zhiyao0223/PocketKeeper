import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class ExpenseGoalService extends ObjectboxService<ExpenseGoal> {
  ExpenseGoalService() : super(MemberCache.objectBox!.store, ExpenseGoal);

  List<ExpenseGoal> getAllActiveGoals() {
    final List<ExpenseGoal> goals = getAll();
    return goals.where((ExpenseGoal goal) => goal.status == 0).toList();
  }

  List<ExpenseGoal> getAllCompletedGoals() {
    final List<ExpenseGoal> goals = getAll();
    return goals.where((ExpenseGoal goal) => goal.status == 1).toList();
  }

  double getTotalSaved() {
    final List<ExpenseGoal> goals = getAllActiveGoals();
    return goals.fold<double>(
        0,
        (double previousValue, ExpenseGoal element) =>
            previousValue + element.currentAmount);
  }

  bool isGoalNameExist(String name) {
    final List<ExpenseGoal> goals = getAll();
    return goals.any((ExpenseGoal goal) => goal.description == name);
  }

  // Return the first goal that is near completion
  ExpenseGoal getHighPriorityGoal() {
    // Sort by completion percentage (total - current) * 100%
    final List<ExpenseGoal> goals = getAllActiveGoals();
    goals.sort((ExpenseGoal a, ExpenseGoal b) {
      final double aPercentage =
          (a.targetAmount - a.currentAmount) / a.targetAmount;
      final double bPercentage =
          (b.targetAmount - b.currentAmount) / b.targetAmount;
      return aPercentage.compareTo(bPercentage);
    });

    return goals.isNotEmpty ? goals.first : ExpenseGoal();
  }

  void restoreBackup(Map<String, dynamic> data) {
    if (data['expense_goal'] == null) {
      return;
    }

    final List<ExpenseGoal> expenses = data['expense_goal']
        .map<ExpenseGoal>((dynamic entity) => ExpenseGoal.fromJson(entity))
        .toList();

    putMany(expenses);
  }
}
