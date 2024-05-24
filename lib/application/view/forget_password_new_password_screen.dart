import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/app_constant.dart';
import 'package:pocketkeeper/application/controller/forget_password_new_password_controller.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/button/button.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/text_style.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class ForgetPasswordNewPasswordScreen extends StatefulWidget {
  const ForgetPasswordNewPasswordScreen({super.key});

  @override
  State<ForgetPasswordNewPasswordScreen> createState() {
    return _ForgetPasswordNewPasswordState();
  }
}

class _ForgetPasswordNewPasswordState
    extends State<ForgetPasswordNewPasswordScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late OutlineInputBorder outlineInputBorder;
  late FPNewPasswordController controller;

  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: customTheme.colorPrimary.withOpacity(0.2),
        width: 2,
      ),
    );

    controller = FxControllerStore.put(FPNewPasswordController(this));
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FPNewPasswordController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // Prevent load UI if data is not finish load
    if (!controller.isDataFetched) return buildCircularLoadingIndicator();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onVerticalDragDown: (_) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: FxSpacing.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTopSection(),
              FxSpacing.height(20),
              _buildPasswordField(),
              FxSpacing.height(20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        Image.asset(
          createNewPasswordImage,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
        FxSpacing.height(20),
        FxText.titleLarge(
          'Create New Password',
          fontWeight: 700,
          fontSize: 28,
        ),
        FxSpacing.height(10),
        FxText.bodyMedium(
          'Please enter your new password',
          fontSize: 18,
          xMuted: true,
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      children: [
        // Password field
        SlideTransition(
          position: controller.passwordAnimation.returnAnimationOffset(),
          child: TextFormField(
            focusNode: passwordFocusNode,
            style: FxTextStyle.bodyMedium(),
            keyboardType: TextInputType.text,
            obscureText: !controller.enablePasswordVisibility,
            decoration: InputDecoration(
              errorMaxLines: 3,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              isDense: true,
              filled: true,
              fillColor: customTheme.white,
              hintText: "Password",
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              border: outlineInputBorder,
              prefixIcon: Icon(
                Icons.lock,
                color: passwordFocusNode.hasFocus
                    ? customTheme.colorPrimary
                    : customTheme.black,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.enablePasswordVisibility
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: customTheme.black,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              contentPadding: FxSpacing.all(16),
              hintStyle: FxTextStyle.bodyMedium(xMuted: true),
              isCollapsed: true,
            ),
            maxLines: 1,
            controller: controller.passwordController,
            validator: controller.validatePassword,
            cursorColor: customTheme.black,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ),
        FxSpacing.height(15),
        // Confirm Password Field
        SlideTransition(
          position: controller.confirmPasswordAnimation.returnAnimationOffset(),
          child: TextFormField(
            focusNode: confirmPasswordFocusNode,
            style: FxTextStyle.bodyMedium(),
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: InputDecoration(
              errorMaxLines: 3,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              isDense: true,
              filled: true,
              fillColor: customTheme.white,
              hintText: "Confirm Password",
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              border: outlineInputBorder,
              prefixIcon: Icon(
                Icons.lock,
                color: confirmPasswordFocusNode.hasFocus
                    ? customTheme.colorPrimary
                    : customTheme.black,
              ),
              contentPadding: FxSpacing.all(16),
              hintStyle: FxTextStyle.bodyMedium(xMuted: true),
              isCollapsed: true,
            ),
            maxLines: 1,
            controller: controller.confirmPasswordController,
            validator: controller.validateConfirmPassword,
            cursorColor: customTheme.black,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: FxButton.rounded(
        onPressed: controller.onSubmitButtonClick,
        backgroundColor: customTheme.colorPrimary,
        child: FxText.bodyMedium(
          'CONFIRM PASSWORD',
          fontWeight: 700,
          color: customTheme.white,
        ),
      ),
    );
  }
}
