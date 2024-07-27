import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/enum/notification_type.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/model/expense_limit.dart';
import 'package:pocketkeeper/application/model/goal_saving_record.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/application/model/notification.dart';
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

    // Create new database
    final store = await openStore(
      directory: dbDir.path,
    );

    final objectBox = ObjectBox._create(store);

    // Generate compulsory data
    objectBox._generateCompulsoryData();
    // objectBox._generateDummyData();

    return objectBox;
  }

  // Generate compulsory data
  void _generateCompulsoryData() {
    // Only add if empty
    // Account
    if (store.box<Accounts>().isEmpty()) {
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
    }

    // Category
    if (store.box<Category>().isEmpty()) {
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
          tmpCategoryName: "Investment",
          tmpIconHex: Icons.insights.codePoint,
          tmpStatus: 0,
          tmpIconColor: Colors.blue[300],
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
    }

    // Role
    if (store.box<Role>().isEmpty()) {
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
    }

    // Notification
    if (store.box<Notifications>().isEmpty()) {
      Notifications notification = Notifications(
        tmpTitle: "Welcome to PocketKeeper",
        tmpDescription:
            "PocketKeeper is a simple and easy-to-use app to manage your expenses and savings.",
        tmpStatus: 0,
        tmpNotificationType: NotificationType.info,
        tmpCreatedDate: DateTime.now(),
      );
      store.box<Notifications>().put(notification);
    }
  }

  /// Generate dummy data
  /// This method is useful for testing purposes.
  void generateDummyData() {
    // Remove existing data
    store.box<Accounts>().removeAll();
    store.box<Expenses>().removeAll();
    store.box<ExpenseGoal>().removeAll();
    store.box<ExpenseLimit>().removeAll();

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
    List<Category> categories = store.box<Category>().getAll();

    // Goals
    List<ExpenseGoal> expenseGoals = [
      ExpenseGoal(
        tmpCurrentAmount: 500,
        tmpTargetAmount: 1000,
        tmpDescription: "New phone",
        tmpIconHex: Icons.phone.codePoint,
        dueDate: DateTime(2024, 8, 24, 10, 33, 30, 0, 0),
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
        tmpCurrentAmount: 1000,
        tmpTargetAmount: 1000,
        tmpDescription: "New bicycle",
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

    // Expenses
    Expenses expense1 = Expenses(
      tmpAmount: 10,
      tmpExpensesDate: DateTime(2024, 7, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Lunch",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense1.category.target = categories[0];
    expense1.account.target = accounts[0];

    Expenses expense2 = Expenses(
      tmpAmount: 20,
      tmpExpensesDate: DateTime(2024, 7, 23, 10, 33, 30, 0, 0),
      tmpDescription: "Daily grocery",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense2.category.target = categories[1];
    expense2.account.target = accounts[0];

    Expenses expense3 = Expenses(
      tmpAmount: 120,
      tmpExpensesDate: DateTime(2024, 7, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Topup RapidKL card",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense3.category.target = categories[2];
    expense3.account.target = accounts[0];

    Expenses expense4 = Expenses(
      tmpAmount: 30,
      tmpExpensesDate: DateTime(2024, 7, 26, 10, 33, 30, 0, 0),
      tmpDescription: "T-Shirt",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense4.category.target = categories[3];
    expense4.account.target = accounts[0];

    Expenses expense5 = Expenses(
      tmpAmount: 500,
      tmpExpensesDate: DateTime(2024, 7, 26, 10, 33, 30, 0, 0),
      tmpDescription: "Movie",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense5.category.target = categories[4];
    expense5.account.target = accounts[0];

    // For August
    Expenses expense6 = Expenses(
      tmpAmount: 10,
      tmpExpensesDate: DateTime(2024, 8, 5, 10, 33, 30, 0, 0),
      tmpDescription: "Lunch",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense6.category.target = categories[0];
    expense6.account.target = accounts[0];

    Expenses expense7 = Expenses(
      tmpAmount: 20,
      tmpExpensesDate: DateTime(2024, 8, 3, 10, 33, 30, 0, 0),
      tmpDescription: "Daily grocery",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense7.category.target = categories[1];
    expense7.account.target = accounts[0];

    Expenses expense8 = Expenses(
      tmpAmount: 120,
      tmpExpensesDate: DateTime(2024, 8, 3, 10, 33, 30, 0, 0),
      tmpDescription: "Rent car",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense8.category.target = categories[2];
    expense8.account.target = accounts[0];

    Expenses expense9 = Expenses(
      tmpAmount: 30,
      tmpExpensesDate: DateTime(2024, 8, 6, 10, 33, 30, 0, 0),
      tmpDescription: "T-Shirt",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense9.category.target = categories[3];
    expense9.account.target = accounts[0];

    Expenses expense10 = Expenses(
      tmpAmount: 500,
      tmpExpensesDate: DateTime(2024, 8, 5, 10, 33, 30, 0, 0),
      tmpDescription: "Movie",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense10.category.target = categories[4];
    expense10.account.target = accounts[0];

    // For June
    Expenses expense11 = Expenses(
      tmpAmount: 10,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Lunch",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );

    expense11.category.target = categories[0];
    expense11.account.target = accounts[0];

    Expenses expense12 = Expenses(
      tmpAmount: 20,
      tmpExpensesDate: DateTime(2024, 6, 23, 10, 33, 30, 0, 0),
      tmpDescription: "Daily grocery",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense12.category.target = categories[1];
    expense12.account.target = accounts[0];

    Expenses expense13 = Expenses(
      tmpAmount: 120,
      tmpExpensesDate: DateTime(2024, 6, 20, 10, 33, 30, 0, 0),
      tmpDescription: "Topup Grab Wallet",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense13.category.target = categories[2];
    expense13.account.target = accounts[0];

    Expenses expense14 = Expenses(
      tmpAmount: 30,
      tmpExpensesDate: DateTime(2024, 6, 26, 10, 33, 30, 0, 0),
      tmpDescription: "T-Shirt",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense14.category.target = categories[3];
    expense14.account.target = accounts[0];

    Expenses expense15 = Expenses(
      tmpAmount: 500,
      tmpExpensesDate: DateTime(2024, 6, 26, 10, 33, 30, 0, 0),
      tmpDescription: "Movie",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense15.category.target = categories[4];
    expense15.account.target = accounts[0];

    store.box<Expenses>().putMany([
      expense1,
      expense2,
      expense3,
      expense4,
      expense5,
      expense6,
      expense7,
      expense8,
      expense9,
      expense10,
      expense11,
      expense12,
      expense13,
      expense14,
      expense15,
    ]);

    // Income
    Expenses income1 = Expenses(
      tmpAmount: 4000,
      tmpExpensesDate: DateTime(2024, 7, 29, 10, 33, 30, 0, 0),
      tmpDescription: "Salary",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income1.category.target = categories[16];
    income1.account.target = accounts[1];

    Expenses income2 = Expenses(
      tmpAmount: 1000,
      tmpExpensesDate: DateTime(2024, 7, 30, 10, 33, 30, 0, 0),
      tmpDescription: "KPI Bonus",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income2.category.target = categories[17];
    income2.account.target = accounts[1];

    Expenses income3 = Expenses(
      tmpAmount: 200,
      tmpExpensesDate: DateTime(2024, 8, 1, 10, 33, 30, 0, 0),
      tmpDescription: "Gift from friend",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income3.category.target = categories[18];
    income3.account.target = accounts[1];

    // For August
    Expenses income4 = Expenses(
      tmpAmount: 4000,
      tmpExpensesDate: DateTime(2024, 8, 29, 10, 33, 30, 0, 0),
      tmpDescription: "Salary",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income4.category.target = categories[16];
    income4.account.target = accounts[1];

    Expenses income5 = Expenses(
      tmpAmount: 1000,
      tmpExpensesDate: DateTime(2024, 8, 30, 10, 33, 30, 0, 0),
      tmpDescription: "Commission",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income5.category.target = categories[17];
    income5.account.target = accounts[1];

    Expenses income6 = Expenses(
      tmpAmount: 200,
      tmpExpensesDate: DateTime(2024, 8, 1, 10, 33, 30, 0, 0),
      tmpDescription: "Stock Investment",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income6.category.target = categories[19];
    income6.account.target = accounts[1];

    // For June
    Expenses income7 = Expenses(
      tmpAmount: 4000,
      tmpExpensesDate: DateTime(2024, 6, 29, 10, 33, 30, 0, 0),
      tmpDescription: "Salary",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income7.category.target = categories[16];
    income7.account.target = accounts[1];

    Expenses income8 = Expenses(
      tmpAmount: 1000,
      tmpExpensesDate: DateTime(2024, 6, 30, 10, 33, 30, 0, 0),
      tmpDescription: "Bonus",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income8.category.target = categories[17];
    income8.account.target = accounts[1];

    Expenses income9 = Expenses(
      tmpAmount: 200,
      tmpExpensesDate: DateTime(2024, 6, 1, 10, 33, 30, 0, 0),
      tmpDescription: "Gift from family",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income9.category.target = categories[18];
    income9.account.target = accounts[1];

    store.box<Expenses>().putMany([
      income1,
      income2,
      income3,
      income4,
      income5,
      income6,
      income7,
      income8,
      income9,
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
  }

  Future<bool> resetDatabase() async {
    try {
      clear();
      MemberCache.objectBox = await create();

      return true;
    } catch (e) {
      log("Error deleting database: $e");
      return false;
    }
  }
}
