import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/service/account_service.dart';
import 'package:pocketkeeper/application/service/app_setting_service.dart';
import 'package:pocketkeeper/application/service/category_service.dart';
import 'package:pocketkeeper/application/service/expense_goal_service.dart';
import 'package:pocketkeeper/application/service/expense_limit_service.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/application/service/goal_saving_record_service.dart';

import '../../template/state_management/controller.dart';

class NavigationController extends FxController {
  bool isDataFetched = false;

  // Navigation Index
  int bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    // Fetch all data and store in global variable
    ExpenseCache.expenseCategories = CategoryService().getExpenseCategories();
    ExpenseCache.incomeCategories = CategoryService().getIncomeCategories();
    ExpenseCache.expenses = ExpenseService().getAllActiveExpenses();
    ExpenseCache.incomes = ExpenseService().getAllActiveIncomes();
    ExpenseCache.accounts = AccountService().getAllActiveAccounts();
    ExpenseCache.expenseLimits =
        ExpenseLimitService().getAllActiveExpenseLimits();
    ExpenseCache.expenseGoals = ExpenseGoalService().getAllActiveGoals();
    ExpenseCache.goalSavingRecords =
        GoalSavingRecordService().getAllActiveRecords();

    MemberCache.appSetting = AppSettingService().getAppSetting();

    isDataFetched = true;
    update();
  }

  @override
  String getTag() {
    return "NavigationController";
  }
}
