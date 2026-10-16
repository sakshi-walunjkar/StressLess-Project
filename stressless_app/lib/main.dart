import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/stress_provider.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const StressLessApp());
}

class StressLessApp extends StatelessWidget {
  const StressLessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StressProvider()),
      ],
      child: MaterialApp(
        title: 'StressLess',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
