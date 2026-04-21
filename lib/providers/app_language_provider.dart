import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _languagePreferenceKey = 'app_language_code';

final appLanguageProvider = NotifierProvider<AppLanguageNotifier, String>(
  AppLanguageNotifier.new,
);

class AppLanguageNotifier extends Notifier<String> {
  @override
  String build() {
    return 'ja';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languagePreferenceKey);
    if (code == 'en' || code == 'ja') {
      state = code!;
    }
  }

  Future<void> setLanguage(String code) async {
    final normalized = (code == 'en') ? 'en' : 'ja';
    state = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languagePreferenceKey, normalized);
  }
}
