import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/register_controller.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/widgets.dart';
import 'package:pocketkeeper/theme/themes.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late RegisterController controller;
  late OutlineInputBorder outlineInputBorder;

  FocusNode usernameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

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

    controller = FxControllerStore.put(RegisterController(this));
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<RegisterController>(
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
      return _buildLoading();
    }

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
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTopSection(),
              FxSpacing.height(20),
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUsernameField(),
                    FxSpacing.height(15),
                    _buildEmailField(),
                    FxSpacing.height(15),
                    _buildPasswordField(),
                  ],
                ),
              ),
              FxSpacing.height(20),
              SizedBox(
                width: double.infinity,
                child: FxButton.rounded(
                  onPressed: controller.onRegisterClick,
                  backgroundColor: customTheme.colorPrimary,
                  child: FxText.bodyMedium(
                    'REGISTER',
                    fontWeight: 700,
                    color: customTheme.white,
                  ),
                ),
              ),
              FxSpacing.height(20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FxText.labelMedium(
                      'Already have an account? ',
                      xMuted: true,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: FxText.labelMedium(
                        'Login here',
                        color: customTheme.colorPrimary,
                        fontWeight: 600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Display spinner while loading
  Widget _buildLoading() {
    return CircularProgressIndicator(
      backgroundColor: customTheme.white,
      color: customTheme.colorPrimary,
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        FxSpacing.height(20),
        FxText.titleLarge(
          "Let's Get Started!",
          fontWeight: 700,
          fontSize: 28,
        ),
        FxSpacing.height(10),
        FxText.bodyMedium(
          'Create an account to get all features',
          fontSize: 18,
          xMuted: true,
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return SlideTransition(
      position: controller.userAnimation.returnAnimationOffset(),
      child: TextFormField(
        focusNode: usernameFocusNode,
        style: FxTextStyle.bodyMedium(),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: customTheme.white,
          hintText: "Username",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          prefixIcon: Icon(
            Icons.person,
            color: usernameFocusNode.hasFocus
                ? customTheme.colorPrimary
                : customTheme.black,
          ),
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodyMedium(xMuted: true),
          isCollapsed: true,
        ),
        maxLines: 1,
        controller: controller.usernameController,
        validator: controller.validateUsername,
        cursorColor: customTheme.black,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      ),
    );
  }

  Widget _buildEmailField() {
    return SlideTransition(
      position: controller.emailAnimation.returnAnimationOffset(),
      child: TextFormField(
        focusNode: emailFocusNode,
        style: FxTextStyle.bodyMedium(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: customTheme.white,
          hintText: "Email Address",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          prefixIcon: Icon(
            Icons.email,
            color: emailFocusNode.hasFocus
                ? customTheme.colorPrimary
                : customTheme.black,
          ),
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodyMedium(xMuted: true),
          isCollapsed: true,
        ),
        maxLines: 1,
        controller: controller.emailController,
        validator: controller.validateEmail,
        cursorColor: customTheme.black,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      ),
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
}
