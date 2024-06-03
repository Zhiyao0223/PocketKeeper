import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/setting_controller.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import '../../template/state_management/state_management.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() {
    return _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingScreen> {
  late CustomTheme customTheme;
  late SettingController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(SettingController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SettingController>(
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: MediaQuery.of(context).padding.top,
        ),
        child: ListView(
          children: [
            // Appbar
            _buildAppBarHeader(),

            // Profile
            _buildProfileHeader(),
            FxSpacing.height(20),

            // General Setting
            _buildGeneralSettings(),
            FxSpacing.height(20),

            // Transactional Setting
            _buildTransactionalSettings(),
            FxSpacing.height(20),

            // Additional Setting
            _buildAdditionalSettings(),
          ],
        ),
      ),
    );
  }

  // Appbar Header
  Widget _buildAppBarHeader() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // FxText.titleMedium(
          //   'Settings',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // Logout button
          const Spacer(),
          GestureDetector(
            onTap: () {
              // TODO Handle logout
              showToast();
            },
            child: Row(
              children: [
                Icon(Icons.logout, color: customTheme.red, size: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Header
  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            'https://th.bing.com/th/id/OIP.HP55nAQfHY4mlb4v9MxJKAHaEK?rs=1&pid=ImgDetMain',
          ),
        ),
        FxSpacing.width(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FxText.bodyMedium(
              'John Doe',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            FxSpacing.height(4),
            GestureDetector(
              onTap: () {
                // TODO Handle edit profile
                showToast();
              },
              child: Row(
                children: [
                  FxText.labelSmall(
                    'Edit',
                    style: TextStyle(
                      color: customTheme.colorPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  FxSpacing.width(4),
                  Icon(Icons.edit, color: customTheme.colorPrimary, size: 16),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FxText.labelLarge(title),
    );
  }

  // Settings Item
  Widget _buildSettingsItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: customTheme.colorPrimary),
      title: FxText.labelMedium(
        title,
        xMuted: true,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: customTheme.grey.withOpacity(0.6),
        size: 16,
      ),
      onTap: () {
        // TODO Handle navigation to respective screen
        showToast();
      },
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('General Settings'),
        _buildSettingsItem(Icons.person, 'Account Preferences'),
        _buildSettingsItem(Icons.lock, 'Password & Account'),
        _buildSettingsItem(Icons.notifications, 'Notifications Settings'),
        _buildSettingsItem(Icons.language, 'Change Language'),
      ],
    );
  }

  Widget _buildTransactionalSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Transactional Settings'),
        _buildSettingsItem(Icons.flag, 'Set Financial Goals'),
        _buildSettingsItem(Icons.attach_money, 'Set Budgeting Preferences'),
        _buildSettingsItem(Icons.credit_card, 'Manage Your Cards'),
        _buildSettingsItem(Icons.timeline, 'Track financial progress'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAdditionalSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Additional Settings'),
        _buildSettingsItem(Icons.security, 'Two-Factor Authentication'),
        _buildSettingsItem(Icons.color_lens, 'Change App Theme'),
        _buildSettingsItem(Icons.backup, 'Backup Your Account'),
      ],
    );
  }
}
