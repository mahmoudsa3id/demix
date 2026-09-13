import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences? _prefs;

  // Keys
  static const String onboardingKey = 'onboarding';
  static const String languageKey = 'language';

  // Init
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Onboarding
  static Future<void> setOnboarding(bool value) async {
    await _prefs?.setBool(onboardingKey, value);
  }

  static bool get getOnboarding {
    return _prefs?.getBool(onboardingKey) ?? false;
  }

  // Language
  static Future<void> setLanguage(String value) async {
    await _prefs?.setString(languageKey, value);
  }

  static String get getLanguage {
    return _prefs?.getString(languageKey) ?? 'en';
  }
}
