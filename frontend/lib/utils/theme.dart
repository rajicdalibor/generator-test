import 'package:flutter/material.dart';

class ThemeUtil {
  // private constructor to prevent instantiation
  ThemeUtil._();

  /* Use the Material Design color roles to create a color scheme
     This method should hold your APP UI styling by overriding the default Material Design theme e.g.
      - inputDecorationTheme
      - appBarTheme
      - textTheme
      - outlinedButtonTheme
  */
  static ThemeData createThemeData(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 40),
        displayMedium: TextStyle(fontSize: 30),
        displaySmall: TextStyle(fontSize: 24),
        bodyLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 14),
        bodySmall: TextStyle(fontSize: 10),
        headlineLarge: TextStyle(fontSize: 24),
        headlineMedium: TextStyle(fontSize: 20),
        headlineSmall: TextStyle(fontSize: 15),
        labelLarge: TextStyle(fontSize: 15),
        labelMedium: TextStyle(fontSize: 10),
        labelSmall: TextStyle(fontSize: 7),
        titleLarge: TextStyle(fontSize: 24),
        titleMedium: TextStyle(fontSize: 18),
        titleSmall: TextStyle(fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        titleTextStyle: TextStyle(
          fontSize: 24,
          color: colorScheme.onPrimary,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        filled: true,
        labelStyle: TextStyle(
          color: colorScheme.primary,
          fontSize: 16,
        ),
        fillColor: colorScheme.brightness == Brightness.light
            ? Colors.white
            : colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
      ),
    );
  }
}
