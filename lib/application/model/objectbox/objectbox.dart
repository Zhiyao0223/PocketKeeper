import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
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
        print("Error deleting database directory: $e");
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
        tmpIconColor: Colors.blue,
      ),
      Category(
        tmpCategoryName: "Transport",
        tmpIconHex: Icons.directions_bus.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.red,
      ),
      Category(
        tmpCategoryName: "Shopping",
        tmpIconHex: Icons.shopping_cart.codePoint,
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
        tmpCategoryName: "Health",
        tmpIconHex: Icons.local_hospital.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.orange,
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
        tmpIconHex: Icons.money.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.green,
        tmpCategoryType: 1,
      ),
      Category(
        tmpCategoryName: "Gift",
        tmpIconHex: Icons.money.codePoint,
        tmpStatus: 0,
        tmpIconColor: Colors.green,
        tmpCategoryType: 1,
      ),
    ];
    store.box<Category>().putMany(categories);
    categories = store.box<Category>().getAll();

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
      tmpAmount: 1000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Lunch",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense1.category.target = categories[0];
    expense1.account.target = accounts[0];

    Expenses expense2 = Expenses(
      tmpAmount: 2000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Bus Ticket",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense2.category.target = categories[1];
    expense2.account.target = accounts[0];

    Expenses expense3 = Expenses(
      tmpAmount: 3000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "T-Shirt",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense3.category.target = categories[2];
    expense3.account.target = accounts[0];

    Expenses expense4 = Expenses(
      tmpAmount: 4000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Movie",
      tmpExpensesType: 0,
      tmpStatus: 0,
    );
    expense4.category.target = categories[3];
    expense4.account.target = accounts[0];

    Expenses expense5 = Expenses(
      tmpAmount: 5000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Medicine",
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
      tmpAmount: 10000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Salary",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income1.category.target = categories[5];
    income1.account.target = accounts[1];

    Expenses income2 = Expenses(
      tmpAmount: 20000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Bonus",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income2.category.target = categories[6];
    income2.account.target = accounts[1];

    Expenses income3 = Expenses(
      tmpAmount: 30000,
      tmpExpensesDate: DateTime(2024, 6, 24, 10, 33, 30, 0, 0),
      tmpDescription: "Gift",
      tmpExpensesType: 1,
      tmpStatus: 0,
    );
    income3.category.target = categories[7];
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
        (FileSystemEntity value) => print("DB Deleted: ${value.existsSync()}"));
  }
}
