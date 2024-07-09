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

  Map<int, double> getLastContributionMonthAndTotal() {
    final List<ExpenseGoal> goals = getAllActiveGoals();
    final Map<int, double> monthSaving = <int, double>{};

    for (final ExpenseGoal goal in goals) {
      final int month = goal.updatedDate.month;
      final double amount = goal.currentAmount;
      if (monthSaving.containsKey(month)) {
        monthSaving[month] = monthSaving[month]! + amount;
      } else {
        monthSaving[month] = amount;
      }
    }

    final int lastMonth =
        monthSaving.keys.reduce((int a, int b) => a > b ? a : b);
    final double total =
        monthSaving.values.reduce((double a, double b) => a + b);

    return <int, double>{lastMonth: total};
  }

  bool isGoalNameExist(String name) {
    final List<ExpenseGoal> goals = getAll();
    return goals.any((ExpenseGoal goal) => goal.description == name);
  }
}
