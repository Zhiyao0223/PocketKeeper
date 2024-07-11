import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/setting/profile_setting_controller.dart';
import 'package:pocketkeeper/application/view/setting/profile_setting_form_screen.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  ProfileSettingsScreenState createState() => ProfileSettingsScreenState();
}

class ProfileSettingsScreenState extends State<ProfileSettingScreen> {
  late CustomTheme customTheme;
  late ProfileSettingController controller;

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ProfileSettingController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(ProfileSettingController());
  }

  @override
  void dispose() {
    FxControllerStore.delete(controller);
    super.dispose();
  }

  Widget _buildBody() {
    if (!controller.isDataFetched) {
      return buildCircularLoadingIndicator();
    }

    return Scaffold(
      appBar: buildCommonAppBar(
        headerTitle: "Profile",
        context: context,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Show dialog to select image
                controller.updateProfilePicture().then((value) {
                  // Only setstate if image is selected
                  if (value) controller.fetchData();
                });
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        MemoryImage(controller.currentUser.profilePicture!),
                    child: controller.currentUser.profilePicture == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  CircleAvatar(
                    backgroundColor: customTheme.lightPurple,
                    radius: 20,
                    child: Icon(
                      Icons.camera_alt,
                      color: customTheme.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Username, Email and Discord
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FxText.labelLarge('Username'),
                    FxText.bodySmall(
                      controller.currentUser.name,
                      xMuted: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FxText.labelLarge('Email'),
                    FxText.bodySmall(
                      controller.currentUser.email,
                      xMuted: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FxText.labelLarge('Discord'),
                    FxText.bodySmall(
                      controller.currentUser.discordId == ""
                          ? "Not connected"
                          : controller.currentUser.discordId,
                      xMuted: true,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            _buildListTile(
              label: 'Change Username',
              leadingIcon: Icons.person,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfileSettingFormScreen(type: 0);
                    },
                  ),
                ).then((value) {
                  controller.fetchData();
                });
              },
            ),
            const SizedBox(height: 16),
            _buildListTile(
              label: 'Change Password',
              leadingIcon: Icons.lock,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfileSettingFormScreen(type: 1);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            if (controller.currentUser.discordId == "")
              _buildListTile(
                label: 'Link / Unlink Discord',
                leadingIcon: Icons.discord,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ProfileSettingFormScreen(type: 2);
                      },
                    ),
                  ).then((value) {
                    controller.fetchData();
                  });
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String label,
    required IconData leadingIcon,
    required Function() onTap,
  }) {
    return ListTile(
      title: FxText.bodySmall(label),
      leading: Icon(
        leadingIcon,
        color: customTheme.colorPrimary,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
