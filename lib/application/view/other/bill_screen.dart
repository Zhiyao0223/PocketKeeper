import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocketkeeper/application/controller/bill_controller.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/utils/converters/number.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../../template/state_management/state_management.dart';

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
    tabController = TabController(length: 2, vsync: this);

    tabController.animation?.addListener(() {
      int tabControllerIndex =
          tabController.index + tabController.offset.round();

      if (tabControllerIndex != controller.selectedTabIndex) {
        controller.selectedTabIndex = tabControllerIndex;
        controller.fetchData();
      }
    });
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
      length: 2,
      child: Scaffold(
        backgroundColor: customTheme.lightPurple,
        appBar: buildCommonAppBar(
          headerTitle: "Other",
          context: context,
          trailingIcon: Icons.add,
          onTrailingIconPressed: () {},
          bottomWidget: _buildTopTabbar(),
        ),
        body: Container(
          color: customTheme.white.withOpacity(0.9),
          child: TabBarView(
            controller: tabController,
            children: [
              const Center(child: Text('Bills Content')),
              _buildSubscriptionTab(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopTabbar() {
    return TabBar(
      controller: tabController,
      indicatorColor: customTheme.white,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        Tab(
          child: FxText.bodyMedium(
            "Bills",
            color: customTheme.white,
            fontWeight: (controller.selectedTabIndex == 0) ? 900 : 500,
          ),
        ),
        Tab(
          child: FxText.bodyMedium(
            "Subscriptions",
            color: customTheme.white,
            fontWeight: (controller.selectedTabIndex == 1) ? 900 : 500,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxText.bodyLarge(
                  'Your monthly payment\nfor subscriptions',
                  textAlign: TextAlign.center,
                  fontWeight: 600,
                  xMuted: true,
                  color: customTheme.grey,
                ),
                FxText.headlineLarge(
                  "${controller.currencyIndicator}${controller.monthlySubscription.removeExtraDecimal()}",
                  textAlign: TextAlign.center,
                  fontWeight: 700,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: customTheme.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: customTheme.grey.withOpacity(0.8),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildSubscriptionItem(
                  'assets/icons/playstore.png',
                  'Patreon membership',
                  19.99,
                ),
                _buildSubscriptionItem(
                  'assets/icons/playstore.png',
                  'Netflix',
                  12,
                ),
                _buildSubscriptionItem(
                  'assets/icons/playstore.png',
                  'Apple payment',
                  19.99,
                ),
                _buildSubscriptionItem(
                  'assets/icons/playstore.png',
                  'Spotify',
                  6.99,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionItem(
      String imageIconUrl, String name, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(imageIconUrl, width: 40, height: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FxText.labelMedium(
                    name,
                    xMuted: true,
                    fontWeight: 700,
                    color: customTheme.grey,
                  ),
                  FxText.labelMedium(
                      "${controller.currencyIndicator}$price/mo"),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  color: customTheme.grey.withOpacity(0.8),
                  weight: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
