import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/service/expense_goal_service.dart';

import '../../../template/state_management/controller.dart';

class GoalController extends FxController {
  bool isDataFetched = false;

  String currencySymbol = "\$";

  int lastContributionMonth = 1;
  double totalSaved = 0, savingThisMonth = 0, percentageThisMonth = 0;

  List<ExpenseGoal> activeGoals = [], completedGoals = [];

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    // Get the currency symbol
    currencySymbol = MemberCache.appSetting.currencyIndicator;

    // Get all active goals and sort them by due date
    activeGoals = ExpenseGoalService().getAllActiveGoals();
    activeGoals.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    // Get all completed goals and sort them by updated date
    completedGoals = ExpenseGoalService().getAllCompletedGoals();
    completedGoals.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

    // Get the last contribution month (which month, save how many)
    Map<int, double> monthSaving =
        ExpenseGoalService().getLastContributionMonthAndTotal();
    lastContributionMonth = monthSaving.keys.first;
    savingThisMonth = monthSaving.values.first;

    // Get the total saved amount
    totalSaved = ExpenseGoalService().getTotalSaved();

    // Calculate the percentage of saving this month
    percentageThisMonth = (savingThisMonth / totalSaved) * 100;

    isDataFetched = true;
    update();
  }

  void deleteGoal(ExpenseGoal goal) {
    // Delete the goal from the database
    ExpenseGoalService().delete(goal.goalId);

    // Delete from cache
    ExpenseCache.expenseGoals
        .removeWhere((element) => element.goalId == goal.goalId);

    fetchData();
  }

  @override
  String getTag() {
    return "GoalController";
  }
}
