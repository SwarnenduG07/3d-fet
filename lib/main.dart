import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'providers/app_language_provider.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: GrowMeApp()));
}

class GrowMeApp extends ConsumerStatefulWidget {
  const GrowMeApp({super.key});

  @override
  ConsumerState<GrowMeApp> createState() => _GrowMeAppState();
}

class _GrowMeAppState extends ConsumerState<GrowMeApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(appLanguageProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(appLanguageProvider);
    return MaterialApp(
      title: 'GrowMe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: Locale(languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}
