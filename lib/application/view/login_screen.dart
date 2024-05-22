import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/login_controller.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  late CustomTheme customTheme;
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(LoginController());
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
      return CircularProgressIndicator(
        backgroundColor: customTheme.white,
        color: customTheme.colorPrimary,
      );
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Image(
            image: AssetImage('assets/icons/app_icon_1024.png'),
            width: 100,
            height: 100,
          ),
          FxText.bodyLarge('Welcome back!'),
          FxSpacing.height(16),
          FxText.bodyMedium("Log in to your existing account"),
          FxSpacing.height(16),
          FxTextField(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email),
            textFieldType: FxTextFieldType.email,
          ),
          FxSpacing.height(16),
          FxTextField(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock),
            textFieldType: FxTextFieldType.password,
          ),
          FxSpacing.height(16),
          FxButton.medium(
            onPressed: () => {},
            child: FxText.bodyMedium('Forgot password?'),
          ),
          FxSpacing.height(16),
          FxButton.medium(
            onPressed: () => {},
            child: FxText.bodyMedium('Log in'),
          ),
        ],
      ),
    );
  }
}
