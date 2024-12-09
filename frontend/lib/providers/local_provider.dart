import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/language_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, SupportedLanguage>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<SupportedLanguage> {
  LocaleNotifier() : super(SupportedLanguage.german) {
    loadLocale();
  }

  Future<void> setLang(SupportedLanguage lang) async {
    if (!SupportedLanguage.values.contains(lang)) return;
    state = lang;
  }

  Future<void> loadLocale() async {
    Locale? deviceLocale = await Devicelocale.defaultAsLocale;
    state = SupportedLanguage.getSupportedLang(deviceLocale?.languageCode);
  }
}
