import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/bill_controller.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../template/state_management/state_management.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() {
    return _BillScreenState();
  }
}

class _BillScreenState extends State<BillScreen>
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
            _buildSubscriptionTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionTab() {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Your monthly payment\nfor subscriptions',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '\$61.88',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        _buildSubscriptionItem(
          'assets/patreon_icon.png',
          'Patreon membership',
          '\$19.99/mo',
        ),
        _buildSubscriptionItem(
          'assets/netflix_icon.png',
          'Netflix',
          '\$12/mo',
        ),
        _buildSubscriptionItem(
          'assets/apple_icon.png',
          'Apple payment',
          '\$19.99/mo',
        ),
        _buildSubscriptionItem(
          'assets/spotify_icon.png',
          'Spotify',
          '\$6.99/mo',
        ),
      ],
    );
  }

  Widget _buildSubscriptionItem(
      String imageIconUrl, String name, String price) {
    return ListTile(
      leading: Image.asset(imageIconUrl, width: 40, height: 40),
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(price),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
