import 'package:flutter/material.dart';
import '../controller/home_page_controller.dart';
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
    extends State<ForgetPasswordNewPasswordScreen> {
  late CustomTheme customTheme;
  late HomePageController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(HomePageController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<HomePageController>(
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
      appBar: AppBar(
        title: Text('New Password'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/new_password.png'),
            SizedBox(height: 20),
            Text(
              'New Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Please write your new password.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your logic here
              },
              child: Text('Confirm Password'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.purple,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
