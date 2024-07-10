import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/setting/profile_setting_controller.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingScreen> {
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
        headerTitle: "Profile Settings",
        context: context,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Show dialog to select image
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

            // Email and Discord
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.labelLarge('Email', style: TextStyle(fontSize: 16)),
                    Text('test@gmail.com', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email', style: TextStyle(fontSize: 16)),
                    Text('test@gmail.com', style: TextStyle(fontSize: 14)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildTextField('Username', 'JohnDoe'),
            const SizedBox(height: 16),
            _buildTextField('New Password', '', obscureText: true),
            const SizedBox(height: 16),
            _buildTextField('Confirm New Password', '', obscureText: true),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement save functionality
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue,
      {bool obscureText = false}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      controller: TextEditingController(text: initialValue),
    );
  }
}
