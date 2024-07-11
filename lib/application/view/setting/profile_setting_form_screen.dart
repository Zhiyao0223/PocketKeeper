import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketkeeper/application/controller/setting/profile_setting_form_controller.dart';
import 'package:pocketkeeper/template/state_management/builder.dart';
import 'package:pocketkeeper/template/state_management/controller_store.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

class ProfileSettingFormScreen extends StatefulWidget {
  /*
  Type
  1: Username
  2: Password
  3: Discord
  */
  final int type;

  const ProfileSettingFormScreen({super.key, required this.type});

  @override
  ProfileSettingFormScreenState createState() =>
      ProfileSettingFormScreenState();
}

class ProfileSettingFormScreenState extends State<ProfileSettingFormScreen> {
  late CustomTheme customTheme;
  late ProfileSettingFormController controller;

  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ProfileSettingFormController>(
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

    controller =
        FxControllerStore.put(ProfileSettingFormController(widget.type));
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
        headerTitle: controller.appbarTitle,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (controller.selectedType == 2)
            ? _buildDiscordWidget()
            : Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // Change username
                    if (controller.selectedType == 0)
                      _buildTextField(
                        label: "Username",
                        controller: controller.nameController,
                        validator: controller.validateUsername,
                      ),

                    // Change password
                    if (controller.selectedType == 1) ...[
                      _buildTextField(
                        label: "Current Password",
                        obscureText: true,
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Password",
                        obscureText: true,
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                      ),
                    ],

                    // Submit button
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customTheme.colorPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.5,
                          48,
                        ),
                      ),
                      onPressed: () {
                        controller.submitChange().then((value) {
                          if (value) {
                            showToast(
                              customMessage: "Profile updated successfully",
                            );
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      child: FxText.bodyMedium(
                        "Save",
                        color: customTheme.white,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDiscordWidget() {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: const FxText.bodySmall("Discord ID"),
          leading: Icon(
            Icons.discord,
            color: customTheme.colorPrimary,
          ),
          trailing: FxText.bodySmall(
            controller.currentUser.discordId != ""
                ? controller.currentUser.discordId
                : "Not linked",
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: customTheme.colorPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.3,
              48,
            ),
          ),
          onPressed: () async {
            try {
              await controller.linkDiscord().then((value) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: FxText.bodyMedium(
                        (value < 1000) ? "Link Status" : "Unlink Status",
                        textAlign: TextAlign.center,
                      ),
                      content: (value < 1000)
                          ? const FxText.bodySmall(
                              "Successfully Unlinked Discord Account",
                              textAlign: TextAlign.start,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FxText.bodySmall(
                                  "Please enter below code to our discord bot to link your account.",
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    FxText.labelMedium(
                                      value.toString(),
                                      color: customTheme.colorPrimary,
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(text: value.toString()),
                                        );
                                        showToast(
                                          customMessage: "Copied to clipboard",
                                        );
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      actionsAlignment: MainAxisAlignment.end,
                      actions: [
                        Row(
                          children: [
                            if (value > 1000) ...[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: customTheme.colorPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),
                                ),
                                onPressed: () {
                                  controller.redirectDiscord();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.open_in_new,
                                      color: customTheme.white,
                                    ),
                                    const SizedBox(width: 8),
                                    FxText.bodySmall(
                                      "Discord",
                                      color: customTheme.white,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: customTheme.colorPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.close, color: customTheme.white),
                                  const SizedBox(width: 8),
                                  FxText.bodyMedium(
                                    "Close",
                                    color: customTheme.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              });
            } on SocketException {
              showToast(customMessage: "No internet connection");
            } catch (e) {
              showToast(customMessage: "An error occurred");
            }
          },
          child: FxText.bodyMedium(
            controller.currentUser.discordId != ""
                ? "Unlink Discord"
                : "Link Discord",
            color: customTheme.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      controller: controller,
      validator: validator,
    );
  }
}
