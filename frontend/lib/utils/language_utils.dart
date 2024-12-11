import 'dart:ui';

// Update this enum to include the languages you want to support
enum SupportedLanguage {
  english,
  german;

  static SupportedLanguage getSupportedLang(String? langCode) {
    if (langCode == 'de') {
      return SupportedLanguage.german;
    }
    return SupportedLanguage.english;
  }

  static SupportedLanguage getSupportedLangFromString(String language) {
    if (language == SupportedLanguage.german.name) {
      return SupportedLanguage.german;
    }
    return SupportedLanguage.english;
  }

  Locale getLocale() {
    switch (this) {
      case SupportedLanguage.english:
        return const Locale('en');
      case SupportedLanguage.german:
        return const Locale('de');
      default:
        return const Locale('de');
    }
  }
}
