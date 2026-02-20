import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/setup/setup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: GrowMeApp()));
}

class GrowMeApp extends StatelessWidget {
  const GrowMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrowMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SetupScreen(),
    );
  }
}
