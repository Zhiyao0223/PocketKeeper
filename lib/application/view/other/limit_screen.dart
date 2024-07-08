import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/other/limit_controller.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/semi_progress_indicator.dart';
import '../../../template/state_management/state_management.dart';

class LimitScreen extends StatefulWidget {
  const LimitScreen({super.key});

  @override
  State<LimitScreen> createState() {
    return _LimitScreenState();
  }
}

class _LimitScreenState extends State<LimitScreen>
    with SingleTickerProviderStateMixin {
  late CustomTheme customTheme;
  late LimitController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(LimitController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<LimitController>(
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

    return Scaffold(
      backgroundColor: customTheme.lightPurple,
      appBar: buildCommonAppBar(
        headerTitle: "Category Limits",
        context: context,
      ),
      body: Column(
        children: [
          _buildSemiCircleChart(),
          _buildBudgetOverview(),
          _buildCreateBudgetButton(),
          Expanded(
            child: _buildBudgetList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetOverview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(controller.getTotalBudget(), 'Total Budgets'),
                _buildStat(controller.getTotalSpent(), 'Total Spent'),
                _buildStat('${controller.remainingDays} days', 'End of Month'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        FxText.labelMedium(
          value,
          color: customTheme.white,
        ),
        FxText.bodySmall(
          label,
          color: customTheme.white,
          xMuted: true,
          fontSize: 12,
        ),
      ],
    );
  }

  Widget _buildCreateBudgetButton() {
    return ElevatedButton(
      child: const Text('Create Budget'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {},
    );
  }

  Widget _buildBudgetList() {
    return ListView(
      children: [
        _buildBudgetItem('Bills & Utilities', 200, Icons.receipt),
        _buildBudgetItem('Food & Beverage', 800, Icons.local_bar),
      ],
    );
  }

  Widget _buildBudgetItem(String title, int amount, IconData icon) {
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: const LinearProgressIndicator(value: 0),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('$amount', style: const TextStyle(color: Colors.white)),
          Text('Left $amount',
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSemiCircleChart() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 165,
      child: CustomPaint(
        painter: SemiCircleProgressPainter(
          progress: controller.chartProgress,
          color: customTheme.lime,
          backgroundColor: customTheme.white.withOpacity(0.87),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            FxText.bodyMedium(
              'Amount you can spend',
              color: customTheme.white,
              xMuted: true,
            ),
            FxText.labelMedium(
              controller.availableBalance.toCommaSeparated(),
              fontSize: 40,
              color: customTheme.lime,
              fontWeight: 600,
            ),
          ],
        ),
      ),
    );
  }
}
