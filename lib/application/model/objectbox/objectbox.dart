import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Give dummy data
    // Account
    List<Accounts> accounts = [
      Accounts(
        accountName: "Cash",
        status: 0,
        accountIcon: Icons.account_balance_wallet,
      ),
      Accounts(
        accountName: "Bank",
        status: 0,
        accountIcon: Icons.account_balance,
      ),
      Accounts(
        accountName: "Credit Card",
        status: 0,
        accountIcon: Icons.credit_card,
      ),
      Accounts(
        accountName: "Debit Card",
        status: 0,
        accountIcon: Icons.credit_card,
      ),
    ];

    // Category
    List<Category> categories = [
      Category(
        tmpCategoryName: "Food",
        tmpIcon: Icons.fastfood,
        tmpStatus: 0,
        tmpIconColor: Colors.blue,
      ),
      Category(
        tmpCategoryName: "Transport",
        tmpIcon: Icons.directions_bus,
        tmpStatus: 0,
        tmpIconColor: Colors.red,
      ),
      Category(
        tmpCategoryName: "Shopping",
        tmpIcon: Icons.shopping_cart,
        tmpStatus: 0,
        tmpIconColor: Colors.green,
      ),
      Category(
        tmpCategoryName: "Entertainment",
        tmpIcon: Icons.movie,
        tmpStatus: 0,
        tmpIconColor: Colors.purple,
      ),
      Category(
        tmpCategoryName: "Health",
        tmpIcon: Icons.local_hospital,
        tmpStatus: 0,
        tmpIconColor: Colors.orange,
      ),
    ];

    // Expenses
    List<Expenses> expenses = [
      Expenses(
        tmpAmount: 1000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Food",
          tmpIcon: Icons.fastfood,
          tmpStatus: 0,
          tmpIconColor: Colors.blue,
        ),
        tmpDescription: "Lunch",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 2000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Transport",
          tmpIcon: Icons.directions_bus,
          tmpStatus: 0,
          tmpIconColor: Colors.red,
        ),
        tmpDescription: "Bus",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 3000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Shopping",
          tmpIcon: Icons.shopping_cart,
          tmpStatus: 0,
          tmpIconColor: Colors.green,
        ),
        tmpDescription: "Shirt",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 4000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Entertainment",
          tmpIcon: Icons.movie,
          tmpStatus: 0,
          tmpIconColor: Colors.purple,
        ),
        tmpDescription: "Movie",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 5000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Health",
          tmpIcon: Icons.local_hospital,
          tmpStatus: 0,
          tmpIconColor: Colors.orange,
        ),
        tmpDescription: "Medicine",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      // More dummy data
      Expenses(
        tmpAmount: 1000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Food",
          tmpIcon: Icons.fastfood,
          tmpStatus: 0,
          tmpIconColor: Colors.blue,
        ),
        tmpDescription: "Dinner",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 2000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Transport",
          tmpIcon: Icons.directions_bus,
          tmpStatus: 0,
          tmpIconColor: Colors.red,
        ),
        tmpDescription: "Taxi",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 3000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Shopping",
          tmpIcon: Icons.shopping_cart,
          tmpStatus: 0,
          tmpIconColor: Colors.green,
        ),
        tmpDescription: "Shoes",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 4000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Entertainment",
          tmpIcon: Icons.movie,
          tmpStatus: 0,
          tmpIconColor: Colors.purple,
        ),
        tmpDescription: "Concert",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 5000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Health",
          tmpIcon: Icons.local_hospital,
          tmpStatus: 0,
          tmpIconColor: Colors.orange,
        ),
        tmpDescription: "Doctor",
        tmpExpensesType: 0,
        tmpStatus: 0,
      ),
    ];

    // Income
    List<Expenses> incomes = [
      Expenses(
        tmpAmount: 10000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Salary",
          tmpIcon: Icons.money,
          tmpStatus: 0,
          tmpIconColor: Colors.green,
        ),
        tmpDescription: "June Salary",
        tmpExpensesType: 1,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 20000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Bonus",
          tmpIcon: Icons.money,
          tmpStatus: 0,
          tmpIconColor: Colors.green,
        ),
        tmpDescription: "June Bonus",
        tmpExpensesType: 1,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 30000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Gift",
          tmpIcon: Icons.money,
          tmpStatus: 0,
          tmpIconColor: Colors.green,
        ),
        tmpDescription: "Gift",
        tmpExpensesType: 1,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 40000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Investment",
          tmpIcon: Icons.money,
          tmpStatus: 0,
          tmpIconColor: Colors.green,
        ),
        tmpDescription: "Investment",
        tmpExpensesType: 1,
        tmpStatus: 0,
      ),
      Expenses(
        tmpAmount: 50000,
        tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpAccount: Accounts(
          accountName: "Cash",
          status: 0,
          accountIcon: Icons.account_balance_wallet,
        ),
        tmpCategory: Category(
          tmpCategoryName: "Other",
          tmpIcon: Icons.money,
          tmpStatus: 0,
          tmpIconColor: Colors.green,
        ),
        tmpDescription: "Other",
        tmpExpensesType: 1,
        tmpStatus: 0,
      ),
    ];

    store.box<Accounts>().putMany(accounts);
    store.box<Category>().putMany(categories);
    store.box<Expenses>().putMany(expenses);
    store.box<Expenses>().putMany(incomes);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();

    final store = await openStore(
      directory: p.join(docsDir.path, "pocketkeeper"),
    );

    return ObjectBox._create(store);
  }

  /// Close the store.
  /// Call this method when the app is closed.
  /// This method should be called only once.
  void close() {
    store.close();
  }

  /// Clear all data from the store.
  /// This method should be called only once.
  /// This method is useful for testing purposes.
  void clear() async {
    close();

    Directory docDir = await getApplicationDocumentsDirectory();
    Directory('${docDir.path}/pocketkeeper').delete().then(
        (FileSystemEntity value) => print("DB Deleted: ${value.existsSync()}"));
  }
}
