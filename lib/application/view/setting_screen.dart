import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/setting_controller.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/view/analytic_screen.dart';
import 'package:pocketkeeper/application/view/login_screen.dart';
import 'package:pocketkeeper/application/view/setting/profile_setting_screen.dart';
import 'package:pocketkeeper/template/widgets/button/button.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
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

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    super.dispose();
  }

  Widget _buildBody() {
    // Check if all data loaded
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App bar
            buildCommonAppBar(
              headerTitle: 'Settings',
              context: context,
              disableBackButton: true,
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Profile section
                  _buildProfileSection(),
                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // General Settings
                        _buildGeneralSettings(),
                        const Divider(),

                        // Tools
                        _buildToolSettings(),
                        const Divider(),

                        // About Us
                        _buildAboutUsSettings(),
                      ],
                    ),
                  ),
                  // Logout button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customTheme.colorPrimary,
                        minimumSize: const Size(200, 40),
                      ),
                      onPressed: () {
                        // Handle logout
                        controller.onLogoutClick().then((value) {
                          showToast(customMessage: "Logout Success");

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        });
                      },
                      child: FxText.bodyMedium(
                        'Logout',
                        style: TextStyle(color: customTheme.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile header
  Widget _buildProfileSection() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: MemoryImage(MemberCache.user!.profilePicture!),
      ),
      title: FxText.labelLarge(MemberCache.user!.name),
      subtitle: FxText.bodySmall(MemberCache.user!.email),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        // Navigate to profile edit page
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileSettingScreen(),
          ),
        ).then((_) {
          controller.fetchData();
        });
      },
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: FxText.labelLarge(title),
    );
  }

  // Settings Item
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Function() onTapFunction,
  }) {
    return ListTile(
      leading: Icon(icon, color: customTheme.colorPrimary),
      title: FxText.labelMedium(
        title,
        xMuted: true,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTapFunction,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('General Settings'),
        _buildSettingsItem(
          icon: Icons.security,
          title: 'Security Settings',
          onTapFunction: () {
            // Navigate to security settings page
            // TODO
          },
        ),

        _buildSettingsItem(
          icon: Icons.attach_money,
          title: 'Budgeting Preferences',
          onTapFunction: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AnalyticScreen(),
            ),
          ),
        ),
        _buildSettingsItem(
          icon: Icons.notifications,
          title: 'Notifications Settings',
          onTapFunction: () {
            // Navigate to notification settings page
            // TODO
          },
        ),
        // _buildSettingsItem(Icons.color_lens, 'Change App Theme') // Future Enhancement
        // _buildSettingsItem(Icons.language, 'Change Language'), // Future Enhancement
      ],
    );
  }

  // Tools Section
  Widget _buildToolSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Tools'),
        _buildSettingsItem(
          icon: Icons.analytics,
          title: 'Currency Converter',
          onTapFunction: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AnalyticScreen(),
            ),
          ),
        ),
        _buildSettingsItem(
          icon: Icons.backup,
          title: 'Backup & Restore Data',
          onTapFunction: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AnalyticScreen(),
            ),
          ),
        ),
      ],
    );
  }

  // Abous Us Section
  Widget _buildAboutUsSettings() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('About Us'),
        _buildSettingsItem(
          icon: Icons.contact_mail,
          title: 'Contact Us',
          onTapFunction: controller.launchEmail,
        ),
        _buildSettingsItem(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTapFunction: _showPrivacyPolicyPopup,
        ),
        ListTile(
          leading: Icon(Icons.backup, color: customTheme.colorPrimary),
          title: const FxText.labelMedium(
            'About',
            xMuted: true,
          ),
          // ignore: deprecated_member_use_from_same_package
          subtitle: FxText.caption(
            'Version ${MemberCache.appSetting.appVersion}',
            xMuted: true,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  // Privacy policy popup
  void _showPrivacyPolicyPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const FxText.labelLarge(
            'Privacy Policy',
            fontSize: 20,
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.bodyMedium(
                  'This Privacy Policy describes how we collect, use, and disclose information when you use our mobile application.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                FxText.labelMedium(
                  'Information Collection and Use',
                ),
                SizedBox(height: 10),
                FxText.bodyMedium(
                  'We may collect certain information automatically when you use our app, including:',
                  textAlign: TextAlign.justify,
                ),
                FxText.bodyMedium(
                  '• Device Information: We may collect device-specific information such as your device model, operating system version, unique device identifiers, and mobile network information.',
                  textAlign: TextAlign.justify,
                ),
                FxText.bodyMedium(
                  '• Usage Information: We may collect information about how you interact with our app, including the features you use, the pages you visit, and your interactions with advertisements.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                FxText.labelMedium(
                  'Information Sharing',
                ),
                SizedBox(height: 10),
                FxText.bodyMedium(
                  'We may share information with third-party service providers that help us operate and improve our app, such as analytics providers, advertising networks, and payment processors. We may also share information as required by law or to protect our rights.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                FxText.labelMedium(
                  'Contact Us',
                ),
                SizedBox(height: 10),
                FxText.bodyMedium(
                  'If you have any questions about this Privacy Policy, please contact us at zhiyao0223@gmail.com.',
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: [
            FxButton.rounded(
              onPressed: () {
                Navigator.pop(context); // Close the popup
              },
              backgroundColor: customTheme.colorPrimary,
              child: FxText.labelMedium(
                'Close',
                color: customTheme.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
