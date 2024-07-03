import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/service/objectbox_service.dart';

class GoalService extends ObjectboxService<ExpenseGoal> {
  GoalService() : super(MemberCache.objectBox!.store, ExpenseGoal);

  List<ExpenseGoal> getAllActiveGoals() {
    final List<ExpenseGoal> goals = getAll();
    return goals.where((ExpenseGoal goal) => goal.status == 0).toList();
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
}
