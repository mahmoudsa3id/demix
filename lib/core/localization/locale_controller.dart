import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController._();

  static final instance = LocaleController._();

  static const String _localeKey = 'app_locale';

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  Future<void> initialize(SharedPreferences preferences) async {
    final savedLanguage = preferences.getString(_localeKey);

    if (savedLanguage == null || savedLanguage.isEmpty) {
      return;
    }

    _locale = Locale(savedLanguage);
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) {
      return;
    }

    _locale = locale;

    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_localeKey, locale.languageCode);

    notifyListeners();
  }
}
