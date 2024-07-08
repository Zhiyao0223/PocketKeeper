import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/service/account_service.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';

import '../../../template/state_management/controller.dart';

class AddAccountController extends FxController {
  bool isDataFetched = false;

  Accounts? selectedAccount;

  // Form
  TextEditingController accountNameController = TextEditingController();
  int selectedIconHex = Icons.account_balance_wallet.codePoint;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddAccountController(this.selectedAccount) {
    if (selectedAccount != null) {
      accountNameController.text = selectedAccount!.accountName;
      selectedIconHex = selectedAccount!.accountIconHex;
    }
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    accountNameController.dispose();
    super.dispose();
  }

  void fetchData() async {
    isDataFetched = true;

    update();
  }

  String? validateAccountName(String? value) {
    if (validateEmptyString(value)) {
      return "Account name is required";
    } else if (AccountService().isAccountNameExist(value!)) {
      return "Account name already exist";
    }
    return null;
  }

  Future<bool> submitAccount() async {
    if (formKey.currentState!.validate()) {
      if (selectedAccount != null) {
        // Update account
        selectedAccount!.accountName = accountNameController.text;
        selectedAccount!.accountIconHex = selectedIconHex;

        // Update cache
        ExpenseCache.accounts
            .firstWhere((element) => element.id == selectedAccount!.id)
          ..accountName = accountNameController.text
          ..accountIconHex = selectedIconHex;
      } else {
        // Add new account
        selectedAccount = Accounts(
          accountName: accountNameController.text,
          tmpAccountIconHex: selectedIconHex,
        );

        // Add to cache
        ExpenseCache.accounts.add(selectedAccount!);
      }

      // Update database
      AccountService().put(selectedAccount!);
      return true;
    }
    return false;
  }

  @override
  String getTag() {
    return "AddAccountController";
  }
}
