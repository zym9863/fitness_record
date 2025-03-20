import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fitness_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FitnessProvider(),
      child: MaterialApp(
        title: '健身记录器',
        theme: AppTheme.getTheme(),
        home: const HomeScreen(),
      ),
    );
  }
}
