import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/model/expense_limit.dart';
import 'package:pocketkeeper/application/model/goal_saving_record.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/model/role.dart';
import 'objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store);

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();

    // Define the database directory
    final dbDir = Directory(p.join(docsDir.path, "pocketkeeper"));

    // Delete previous database
    if (await dbDir.exists()) {
      try {
        await dbDir.delete(recursive: true);
      } catch (e) {
        log("Error deleting database directory: $e");
      }
    }

    // Create new database
    final store = await openStore(
      directory: dbDir.path,
    );

    // Generate dummy data
    final objectBox = ObjectBox._create(store);
    objectBox._generateDummyData();

    return objectBox;
  }

  /// Generate dummy data
  /// This method is useful for testing purposes.
  void _generateDummyData() {
    // Remove existing data
    store.box<Accounts>().removeAll();
    store.box<Category>().removeAll();
    store.box<Expenses>().removeAll();
    store.box<ExpenseGoal>().removeAll();
    store.box<ExpenseLimit>().removeAll();
    store.box<Role>().removeAll();

    // Give dummy data
    // Account
    List<Accounts> accounts = [
      Accounts(
        accountName: "Cash",
        status: 0,
        tmpAccountIconHex: Icons.account_balance_wallet.codePoint,
      ),
      Accounts(
        accountName: "Bank",
        status: 0,
        tmpAccountIconHex: Icons.account_balance.codePoint,
      ),
      Accounts(
        accountName: "Credit Card",
        status: 0,
        tmpAccountIconHex: Icons.credit_card.codePoint,
      ),
      Accounts(
        accountName: "Debit Card",
        status: 0,
        tmpAccountIconHex: Icons.credit_card.codePoint,
      ),
    ];
    store.box<Accounts>().putMany(accounts);
    accounts = store.box<Accounts>().getAll();

    // Category
    List<Category> categories = [
      Category(
        tmpCategoryName: "Food",
        tmpIconHex: Icons.fastfood.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.amber,
      ),
      Category(
        tmpCategoryName: "Grocery",
        tmpIconHex: Icons.shopping_basket.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.greenAccent[400],
      ),
      Category(
        tmpCategoryName: "Transportation",
        tmpIconHex: Icons.directions_bus.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.blueAccent,
      ),
      Category(
        tmpCategoryName: "Clothing",
        tmpIconHex: Icons.shopify_outlined.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.green,
      ),
      Category(
        tmpCategoryName: "Entertainment",
        tmpIconHex: Icons.movie.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.purple,
      ),
      Category(
        tmpCategoryName: "Sports",
        tmpIconHex: Icons.sports_soccer.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.redAccent,
      ),
      Category(
        tmpCategoryName: "Home",
        tmpIconHex: Icons.home.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.brown,
      ),
      Category(
        tmpCategoryName: "E-commerce",
        tmpIconHex: Icons.shopping_cart.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.tealAccent,
      ),
      Category(
        tmpCategoryName: "Tools",
        tmpIconHex: Icons.build.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.teal,
      ),
      Category(
        tmpCategoryName: "Events",
        tmpIconHex: Icons.event.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.pinkAccent,
      ),
      Category(
        tmpCategoryName: "Dessert",
        tmpIconHex: Icons.cake.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.redAccent[100],
      ),
      Category(
        tmpCategoryName: "Books",
        tmpIconHex: Icons.book.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.blueGrey,
      ),
      Category(
        tmpCategoryName: "Shoes",
        tmpIconHex: Icons.shopping_bag.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.orangeAccent,
      ),
      Category(
        tmpCategoryName: "Games",
        tmpIconHex: Icons.games_outlined.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.deepPurpleAccent,
      ),
      Category(
        tmpCategoryName: "Medical",
        tmpIconHex: Icons.local_hospital.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.lightBlue[300],
      ),
      Category(
        tmpCategoryName: "Others",
        tmpIconHex: Icons.settings.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.grey,
      ),
      Category(
        tmpCategoryName: "Salary",
        tmpIconHex: Icons.money.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.green,
        tmpCategoryType: 1,
      ),
      Category(
        tmpCategoryName: "Bonus",
        tmpIconHex: Icons.card_giftcard.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.orange,
        tmpCategoryType: 1,
      ),
      Category(
        tmpCategoryName: "Gift",
        tmpIconHex: Icons.moped_rounded.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.deepPurple[300],
        tmpCategoryType: 1,
      ),
      Category(
        tmpCategoryName: "Others",
        tmpIconHex: Icons.settings.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.grey,
        tmpCategoryType: 1,
      ),
    ];
    store.box<Category>().putMany(categories);
    categories = store.box<Category>().getAll();

    // Goals
    List<ExpenseGoal> expenseGoals = [
      ExpenseGoal(
        tmpCurrentAmount: 500,
        tmpTargetAmount: 1000,
        tmpDescription: "New phone",
        tmpIconHex: Icons.phone.codePoint,
        dueDate: DateTime(2024, 7, 24, 10, 33, 30, 0, 0),
        tmpStatus: 0,
      ),
      ExpenseGoal(
        tmpCurrentAmount: 1000,
        tmpTargetAmount: 3500,
        tmpDescription: "New laptop",
        tmpIconHex: Icons.laptop.codePoint,
        dueDate: DateTime(2024, 8, 13, 10, 33, 30, 0, 0),
        tmpStatus: 0,
      ),
      ExpenseGoal(
        tmpCurrentAmount: 2000,
        tmpTargetAmount: 30000,
        tmpDescription: "New car",
        tmpIconHex: Icons.directions_car.codePoint,
        dueDate: DateTime(2024, 9, 20, 10, 33, 30, 0, 0),
        tmpStatus: 0,
      ),
      ExpenseGoal(
        tmpCurrentAmount: 10000,
        tmpTargetAmount: 10000,
        tmpDescription: "New house",
        tmpIconHex: Icons.home.codePoint,
        dueDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpUpdatedDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
        tmpStatus: 1,
      ),
    ];
    store.box<ExpenseGoal>().putMany(expenseGoals);
    expenseGoals = store.box<ExpenseGoal>().getAll();

    // Saving Record
    GoalSavingRecord goalSavingRecord1 = GoalSavingRecord(
      tmpAmount: 300,
      tmpSavingDate: DateTime(2024, 6, 21, 10, 33, 30, 0, 0),
      tmpStatus: 0,
    );
    goalSavingRecord1.goal.target = expenseGoals[0];

    GoalSavingRecord goalSavingRecord2 = GoalSavingRecord(
      tmpAmount: 1000,
      tmpSavingDate: DateTime(2024, 6, 22, 10, 33, 30, 0, 0),
      tmpStatus: 0,
    );
    goalSavingRecord2.goal.target = expenseGoals[1];

    GoalSavingRecord goalSavingRecord3 = GoalSavingRecord(
      tmpAmount: 1300,
      tmpSavingDate: DateTime(2024, 5, 23, 10, 33, 30, 0, 0),
      tmpStatus: 0,
    );
    goalSavingRecord3.goal.target = expenseGoals[2];

    GoalSavingRecord goalSavingRecord4 = GoalSavingRecord(
      tmpAmount: 200,
      tmpSavingDate: DateTime(2024, 7, 8, 10, 33, 30, 0, 0),
      tmpStatus: 0,
    );
    goalSavingRecord4.goal.target = expenseGoals[0];

    GoalSavingRecord goalSavingRecord5 = GoalSavingRecord(
      tmpAmount: 700,
      tmpSavingDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpStatus: 0,
    );
    goalSavingRecord5.goal.target = expenseGoals[2];

    store.box<GoalSavingRecord>().putMany([
      goalSavingRecord1,
      goalSavingRecord2,
      goalSavingRecord3,
      goalSavingRecord4,
      goalSavingRecord5,
    ]);

    // Limit
    ExpenseLimit expenseLimit1 = ExpenseLimit(
      tmpAmount: 1500,
      tmpStatus: 0,
    );
    expenseLimit1.category.target = categories[0];

    ExpenseLimit expenseLimit2 = ExpenseLimit(
      tmpAmount: 500,
      tmpStatus: 0,
    );
    expenseLimit2.category.target = categories[1];

    ExpenseLimit expenseLimit3 = ExpenseLimit(
      tmpAmount: 300,
      tmpStatus: 0,
    );
    expenseLimit3.category.target = categories[2];

    ExpenseLimit expenseLimit4 = ExpenseLimit(
      tmpAmount: 200,
      tmpStatus: 0,
    );
    expenseLimit4.category.target = categories[3];

    store.box<ExpenseLimit>().putMany([
      expenseLimit1,
      expenseLimit2,
      expenseLimit3,
      expenseLimit4,
    ]);

    // Role
    List<Role> roles = [
      Role(
        tmpName: "admin",
        tmpId: 0,
      ),
      Role(
        tmpId: 1,
        tmpName: "premium_user",
      ),
      Role(
        tmpName: "normal_user",
        tmpId: 0,
      ),
    ];
    store.box<Role>().putMany(roles);

    // Expenses
    Expenses expense1 = Expenses(
      tmpAmount: 10,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Lunch",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense1.category.target = categories[0];
    expense1.account.target = accounts[0];

    Expenses expense2 = Expenses(
      tmpAmount: 20,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Daily grocery",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense2.category.target = categories[1];
    expense2.account.target = accounts[0];

    Expenses expense3 = Expenses(
      tmpAmount: 120,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Topup RapidKL card",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense3.category.target = categories[2];
    expense3.account.target = accounts[0];

    Expenses expense4 = Expenses(
      tmpAmount: 30,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "T-Shirt",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense4.category.target = categories[3];
    expense4.account.target = accounts[0];

    Expenses expense5 = Expenses(
      tmpAmount: 500,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Movie",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense5.category.target = categories[4];
    expense5.account.target = accounts[0];

    store.box<Expenses>().putMany([
      expense1,
      expense2,
      expense3,
      expense4,
      expense5,
    ]);

    // Income
    Expenses income1 = Expenses(
      tmpAmount: 4000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Salary",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income1.category.target = categories[16];
    income1.account.target = accounts[1];

    Expenses income2 = Expenses(
      tmpAmount: 1000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "KPI Bonus",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income2.category.target = categories[17];
    income2.account.target = accounts[1];

    Expenses income3 = Expenses(
      tmpAmount: 200,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Gift from friend",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income3.category.target = categories[18];
    income3.account.target = accounts[1];

    store.box<Expenses>().putMany([
      income1,
      income2,
      income3,
    ]);
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
        (FileSystemEntity value) => log("DB Deleted: ${value.existsSync()}"));
  }
}
