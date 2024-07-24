import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/view/analytic_screen.dart';
import 'package:pocketkeeper/application/view/dashboard_screen.dart';
import 'package:pocketkeeper/application/view/form_add_expenses_screen.dart';
import 'package:pocketkeeper/application/view/other_screen.dart';
import 'package:pocketkeeper/application/view/setting_screen.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import '../controller/navigation_controller.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class NavigationScreen extends StatefulWidget {
  final int? navigationIndex;
  final bool fromLogin;
  const NavigationScreen({
    super.key,
    this.navigationIndex,
    this.fromLogin = false,
  });

  @override
  State<NavigationScreen> createState() {
    return _NavigationScreenState();
  }
}

class _NavigationScreenState extends State<NavigationScreen> {
  late CustomTheme customTheme;
  late NavigationController controller;
  final LocalAuthentication _localAuth = LocalAuthentication();

  late bool _requireAuthenticated;

  // Navigation bar icon (Dashboard, Analytics, Others, Settings)
  List<IconData> iconList = [
    Icons.dashboard,
    Icons.analytics,
    Icons.tune,
    Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(NavigationController());
    controller.bottomNavIndex = widget.navigationIndex ?? 0;

    // Only need to authenticate if user is not from login or biometric setting is off
    _requireAuthenticated =
        widget.fromLogin || !(MemberCache.appSetting!.isBiometricOn);

    // Authentication will be triggered after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<NavigationController>(
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
      body: _buildPageByNavigationBar(controller.bottomNavIndex),
      floatingActionButton: _buildCenterFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: controller.bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        onTap: (index) => setState(() => controller.bottomNavIndex = index),
        activeColor: customTheme.colorPrimary.withOpacity(0.8),
        borderColor: customTheme.border,
        inactiveColor: customTheme.grey,
        backgroundColor: customTheme.white,
      ),
    );
  }

  Widget _buildPageByNavigationBar(int index) {
    /*
    0: Dashboard
    1: Analytics
    2: Others
    3: Settings
    */
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const AnalyticScreen();
      case 2:
        return const OtherScreen();
      case 3:
        return const SettingScreen();
      default:
        return const DashboardScreen();
    }
  }

  Widget _buildCenterFloatingButton() {
    return FloatingActionButton(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      onPressed: () async {
        // Go to manual add screen
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const FormAddExpensesScreen();
            },
          ),
        ).then((value) {
          // Refresh data after add expenses
          controller.fetchData();
        });
      },
      shape: const CircleBorder(),
      backgroundColor: customTheme.colorPrimary.withOpacity(0.8),
      child: Icon(
        Icons.qr_code_scanner,
        color: customTheme.white,
        size: 30,
      ),
      //params
    );
  }

  Future<void> _authenticate() async {
    // From login or already authenticated
    if (_requireAuthenticated) {
      return;
    }

    final didAuthenticate = await _localAuth.authenticate(
      localizedReason: 'Please authenticate to access the app',
      options: const AuthenticationOptions(biometricOnly: false),
    );

    if (didAuthenticate && mounted) {
      setState(() {
        _requireAuthenticated = true;
      });
    } else {
      // Optionally handle authentication failure (e.g., show a dialog or exit the app)
      showToast(customMessage: 'Authentication failed');
      exit(0);
    }
  }
}
