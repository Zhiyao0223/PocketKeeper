import 'package:pocketkeeper/application/model/category.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/application/model/expense_goal.dart';
import 'package:pocketkeeper/application/model/expense_limit.dart';
import 'package:pocketkeeper/application/model/financial_blog.dart';
import 'package:pocketkeeper/application/model/goal_saving_record.dart';
import 'package:pocketkeeper/application/model/money_account.dart';

// This cache is help to reduce latency in fetching data from database
class ExpenseCache {
  static List<Expenses> expenses = [];
  static List<Expenses> incomes = [];

  // Category
  static List<Category> expenseCategories = [];
  static List<Category> incomeCategories = [];

  // Account
  static List<Accounts> accounts = [];

  // Limit
  static List<ExpenseLimit> expenseLimits = [];

  // Goal
  static List<ExpenseGoal> expenseGoals = [];
  static List<GoalSavingRecord> goalSavingRecords = [];

  // Blog
  static List<FinancialBlog> blogs = [];
}
