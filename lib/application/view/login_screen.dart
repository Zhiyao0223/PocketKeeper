import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/app_constant.dart';
import 'package:pocketkeeper/application/controller/login_controller.dart';
import 'package:pocketkeeper/application/view/forget_password_email_screen.dart';
import 'package:pocketkeeper/application/view/home_screen.dart';
import 'package:pocketkeeper/application/view/register_screen.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/widgets.dart';
import 'package:pocketkeeper/theme/themes.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late LoginController controller;
  late OutlineInputBorder outlineInputBorder;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

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

    controller = FxControllerStore.put(LoginController(this));
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<LoginController>(
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
      appBar: AppBar(),
      body: GestureDetector(
        onVerticalDragDown: (_) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Top section of login form
              _buildTopSection(),
              FxSpacing.height(16),
              // Form
              Form(
                key: controller.formKey,
                child: _buildForm(),
              ),
              // Email

              FxSpacing.height(16),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordEmailScreen(),
                    ),
                  ),
                  child: FxText.labelMedium(
                    'Forgot password?',
                    fontWeight: 600,
                    color: customTheme.colorPrimary,
                  ),
                ),
              ),
              FxSpacing.height(16),
              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FxButton.rounded(
                  onPressed: () {
                    controller.onLoginButtonClick().then((authorized) {
                      if (authorized) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    });
                  },
                  backgroundColor: customTheme.colorPrimary,
                  child: FxText.bodyMedium(
                    'LOG IN',
                    fontWeight: 700,
                    color: customTheme.white,
                  ),
                ),
              ),
              _buildSocialLogin(),
              FxSpacing.height(32),
              // Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FxText.labelMedium(
                    "Don't have an account? ",
                    xMuted: true,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    child: FxText.labelMedium(
                      'Sign Up',
                      color: customTheme.colorPrimary,
                      fontWeight: 600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build top section of login form
  Widget _buildTopSection() {
    return Column(
      children: <Widget>[
        Image.asset(
          appLogoImage,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
        ),
        FxSpacing.height(32),
        FxText.titleLarge(
          'Welcome back!',
          fontWeight: 700,
          fontSize: 28,
        ),
        FxSpacing.height(8),
        FxText.bodyMedium(
          'Log in to your existing account',
          fontSize: 18,
          xMuted: true,
        ),
        FxSpacing.height(16),
      ],
    );
  }

  // Build form
  Widget _buildForm() {
    return Column(
      children: <Widget>[
        _buildEmailField(),
        FxSpacing.height(16),
        _buildPasswordField(),
      ],
    );
  }

  // Display Email Field
  Widget _buildEmailField() {
    return SlideTransition(
      position: controller.emailAnimation.returnAnimationOffset(),
      child: TextFormField(
        focusNode: emailFocusNode,
        style: FxTextStyle.bodyMedium(),
        keyboardType: TextInputType.text,
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
        onTapOutside: (_) {
          // Lost focus change colour
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }

  // Display Password Field
  Widget _buildPasswordField() {
    return SlideTransition(
      position: controller.passwordAnimation.returnAnimationOffset(),
      child: TextFormField(
        focusNode: passwordFocusNode,
        style: FxTextStyle.bodyMedium(),
        keyboardType: TextInputType.text,
        obscureText: controller.enablePasswordVisibility ? false : true,
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
          suffixIcon: InkWell(
            onTap: () {
              controller.togglePasswordVisibility();
            },
            child: Icon(
              controller.enablePasswordVisibility
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: passwordFocusNode.hasFocus
                  ? customTheme.colorPrimary
                  : customTheme.black,
            ),
          ),
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodyMedium(xMuted: true),
          isCollapsed: true,
        ),
        maxLines: 1,
        controller: controller.passwordController,
        validator: controller.validatePassword,
        cursorColor: customTheme.black,
        onTapOutside: (_) {
          // Lost focus change colour
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }

  // Build social login section
  Widget _buildSocialLogin() {
    return Column(
      children: [
        FxSpacing.height(16),
        FxText.labelMedium(
          'Or log in with:',
          xMuted: true,
        ),
        FxSpacing.height(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FxButton.rounded(
              onPressed: controller.onGoogleAccountLoginClick,
              backgroundColor: customTheme.white,
              child: Row(
                children: [
                  Image.asset(
                    googleLogoImage,
                    width: 24,
                    height: 24,
                  ),
                  FxSpacing.width(8),
                  FxText(
                    'Google',
                    color: customTheme.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
