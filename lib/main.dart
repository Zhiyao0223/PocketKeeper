import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketkeeper/application/service/firebase_options.dart';
import 'package:pocketkeeper/application/view/navigation_screen.dart';
import 'package:pocketkeeper/theme/app_theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration from .env file
  await dotenv.load(fileName: ".env");

  // Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // home: const LoginScreen(),
      home: const NavigationScreen(),
    );
  }
}
