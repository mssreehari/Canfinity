import 'package:flutter/material.dart';

class AppTheme {
  // Color Scheme - updated to pink and white
  static const Color primary = Color(0xFFFFC0CB); // Light Pink
  static const Color secondary = Color(0xFFFF69B4); // Hot Pink
  static const Color accent = Color(0xFFFFB6C1); // Pink
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFF8F8F8); // Light Grayish White
  static const Color text = Color(0xFF000000); // Black
  static const Color subtext = Color(0xFF808080); // Gray

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: surface,
          background: background,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: text,
          onBackground: text,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: text),
          bodyMedium: TextStyle(color: text),
          titleLarge: TextStyle(color: text),
          titleMedium: TextStyle(color: text),
          titleSmall: TextStyle(color: subtext),
        ),
      );
}
