import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/bill_controller.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../../template/state_management/state_management.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() {
    return _GoalScreenState();
  }
}

class _GoalScreenState extends State<GoalScreen>
    with SingleTickerProviderStateMixin {
  late CustomTheme customTheme;
  late BillController controller;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(BillController());
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<BillController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // Prevent load UI if data is not finish load
    if (!controller.isDataFetched) {
      // Display spinner while loading
      return buildCircularLoadingIndicator();
    }

    return DefaultTabController(
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 300),
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              // Handle back button press
            },
          ),
          title: const FxText.labelLarge('Other', fontSize: 16),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // Detect tab and go to respective add form
              },
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Goals'),
              Tab(text: 'Limits'),
              Tab(text: 'Bills'),
              Tab(text: 'Accounts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text('Bills Content')),
            const Center(child: Text('Payments Content')),
          ],
        ),
      ),
    );
  }
}
