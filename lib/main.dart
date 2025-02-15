import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/objectbox/objectbox.dart';
import 'package:pocketkeeper/application/service/firebase_options.dart';
import 'package:pocketkeeper/application/view/login_screen.dart';
import 'package:pocketkeeper/application/view/navigation_screen.dart';
import 'package:pocketkeeper/theme/app_theme.dart';
import 'package:pocketkeeper/utils/app_permission.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration from .env file
  await dotenv.load(fileName: ".env");

  // Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get cameras
  MemberCache.cameras = await availableCameras();

  // Initialize local database
  MemberCache.objectBox = await ObjectBox.create();

  // Initialize login
  await MemberCache.initLogin();

  // Request permission
  await AppPermission.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketKeeper',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: (MemberCache.user == null)
          ? const LoginScreen()
          : const NavigationScreen(),
    );
  }
}
