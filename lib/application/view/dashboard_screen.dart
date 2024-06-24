import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/dashboard_controller.dart';
import 'package:pocketkeeper/application/view/notification_screen.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../template/state_management/state_management.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  late CustomTheme customTheme;
  late DashboardController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(DashboardController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<DashboardController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // Check if all data loaded
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi, Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Good Morning',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBalanceCard(
                          'Total Balance', '\$7,783.00', Colors.white),
                      _buildBalanceCard(
                          'Total Expense', '-\$1,187.40', Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.white24,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '30% Of Your Expenses, Looks Good.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSavingsGoals(),
                  const SizedBox(height: 20),
                  _buildWeeklySummary(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTransactionDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String title, String amount, Color amountColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          amount,
          style: TextStyle(
              color: amountColor, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSavingsGoals() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGoalCard(Icons.car_repair, 'Savings On Goals', Colors.blue),
        _buildGoalCard(Icons.fastfood, 'Food Last Week\n-\$100.00', Colors.red),
        // _buildGoalCard(
        //     Icons.attach_money, 'Revenue Last Week\n\$4,000.00', Colors.green),
      ],
    );
  }

  Widget _buildGoalCard(IconData icon, String title, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 40),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildWeeklySummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This Week (26 Nov to 30 Nov)',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const Text(
          'Travel -\$10,000',
          style: TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
        const SizedBox(height: 10),
        const Text(
          'Last Week (19 Nov to 25 Nov)',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExpenseItem('Food', '-\$2,000', '24-11-23', Icons.fastfood),
            _buildExpenseItem(
                'Shopping', '-\$3,000', '23-11-23', Icons.shopping_cart),
            _buildExpenseItem(
                'Bill Payment', '-\$1,500', '20-11-23', Icons.payment),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Last Week (12 Nov to 18 Nov)',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        _buildExpenseItem('Recharge', '-\$1,500', '17-11-23', Icons.phone),
      ],
    );
  }

  Widget _buildExpenseItem(
      String title, String amount, String date, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
        Text(
          '$amount ($date)',
          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction details',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                items: <String>['Nov 2023', 'Dec 2023'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFilterButton('View All'),
              _buildFilterButton('Food'),
              _buildFilterButton('Shopping'),
              const Icon(Icons.search),
            ],
          ),
          const SizedBox(height: 20),
          _buildExpenseDetails(),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title) {
    return TextButton(
      onPressed: () {},
      child: Text(
        title,
        style: const TextStyle(color: Colors.black54, fontSize: 16),
      ),
    );
  }

  Widget _buildExpenseDetails() {
    return Column(
      children: [
        _buildExpenseDetailItem(
            'Travel', '-10,000', '26-11-23', Icons.travel_explore),
        _buildExpenseDetailItem('Food', '-2,000', '24-11-23', Icons.fastfood),
        _buildExpenseDetailItem(
            'Shopping', '-3,000', '23-11-23', Icons.shopping_cart),
        _buildExpenseDetailItem(
            'Bill Payment', '-1,500', '20-11-23', Icons.payment),
        _buildExpenseDetailItem('Recharge', '-1,500', '17-11-23', Icons.phone),
      ],
    );
  }

  Widget _buildExpenseDetailItem(
      String title, String amount, String date, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ],
        ),
        Text(
          '$amount ($date)',
          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      ],
    );
  }
}
