import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import 'auth_screen.dart';
import '../setup/setup_screen.dart';
import '../navigation/main_navigation_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  static const String _rememberLoginKey = 'remember_login';

  String? _loadedUid;
  bool _isLoadingProfile = false;
  bool _isCheckingPersistence = false;

  void _loadProfileForUser(String uid) {
    if (_isLoadingProfile || _loadedUid == uid) return;

    _isLoadingProfile = true;
    Future<void>(() async {
      _isCheckingPersistence = true;
      final prefs = await SharedPreferences.getInstance();
      final remember = prefs.getBool(_rememberLoginKey) ?? true;
      if (!remember) {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        setState(() {
          _loadedUid = null;
          _isLoadingProfile = false;
          _isCheckingPersistence = false;
        });
        return;
      }

      await ref.read(userProfileProvider.notifier).loadFromFirestore(uid);
      if (!mounted) return;
      setState(() {
        _loadedUid = uid;
        _isLoadingProfile = false;
        _isCheckingPersistence = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          );
        }

        if (_isCheckingPersistence) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          if (_loadedUid != null || ref.read(userProfileProvider) != null) {
            ref.read(userProfileProvider.notifier).clearLocalState();
          }
          _loadedUid = null;
          _isLoadingProfile = false;
          _isCheckingPersistence = false;
          return const AuthScreen();
        }

        if (_loadedUid != user.uid) {
          _loadProfileForUser(user.uid);
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.secondary),
            ),
          );
        }

        final profile = ref.watch(userProfileProvider);
        if (profile == null) {
          return const SetupScreen();
        }
        return const MainNavigationScreen();
      },
    );
  }
}
