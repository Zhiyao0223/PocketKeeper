import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/account_service.dart';
import 'package:pocketkeeper/application/service/expense_service.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

import '../../../template/state_management/controller.dart';

class AccountController extends FxController {
  bool isDataFetched = false;
  int selectedAccountIndex = 0, selectedRecordIndex = 0;

  late List<Accounts> accounts;
  Map<int, List<Expenses>> accountExpenses = {};
  late List<double> accountBalances;
  late String currencyIndicator;

  // Constructor
  AccountController();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    ExpenseService expenseService = ExpenseService();

    currencyIndicator = MemberCache.appSetting.currencyIndicator;
    accounts = ExpenseCache.accounts;

    // TODO: Change back to current month by removing params
    accountBalances = expenseService.getAccountBalancesInMonth(month: 6);

    // Get all expenses for each account
    for (int i = 0; i < accounts.length; i++) {
      accountExpenses[i] =
          expenseService.getExpensesByAccountId(accounts[i].id);
    }

    isDataFetched = true;
    update();
  }

  void setCurrentAccount(int index) {
    selectedAccountIndex = index;
    update();
  }

  void deleteAccount() {
    AccountService accountService = AccountService();
    // Check if there is any expenses linked to the account
    if (accountService
        .isAnyRecordLinkedToAccount(accounts[selectedAccountIndex].id)) {
      showToast(
          customMessage: "Failed. There are expenses linked to this account");
      return;
    }

    // Delete db
    accountService.delete(accounts[selectedAccountIndex].id);

    // Delete cache
    ExpenseCache.accounts.removeAt(selectedAccountIndex);

    // Set selected account to first account
    selectedAccountIndex = 0;

    // Show confirmation
    showToast(customMessage: "Account deleted successfully");
    update();
  }

  @override
  String getTag() {
    return "AccountController";
  }
}
