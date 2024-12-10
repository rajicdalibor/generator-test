import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, Brightness>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<Brightness> {
  ThemeNotifier() : super(Brightness.light);

  void toggleTheme(bool isDark) {
    state = isDark ? Brightness.dark : Brightness.light;
  }
}
