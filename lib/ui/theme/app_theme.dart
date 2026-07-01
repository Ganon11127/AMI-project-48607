import 'package:flutter/material.dart';

class AppTheme {
  static const Color accent = Color(0xff3600FF);
  static const Color darkBg = Color(0xff1E1E1E);
  static const Color lightBg = Color(0xffF0EAD6);
  static const Color darkCard = Color(0xff282828);
  static const Color darkSubCard = Color(0xff383838);
  static const Color lightCard = Color(0xffFAF6EF);
  static const Color lightSubCard = Color(0xffF5F0E8);

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: accent,
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accent,
        surface: lightCard,
        surfaceContainerHighest: lightSubCard,
        onPrimary: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBg,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: accent),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: accent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        selectedIconTheme: IconThemeData(color: Colors.black),
        unselectedIconTheme: IconThemeData(color: Colors.black54),
        showUnselectedLabels: false,
        showSelectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
        ),
      ),
      dividerColor: Colors.grey.shade300,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accent,
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent,
        surface: darkCard,
        surfaceContainerHighest: darkSubCard,
        onPrimary: Colors.white,
        onSurface: Colors.white,
        error: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: accent),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleMedium: TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: accent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.white70),
        showUnselectedLabels: false,
        showSelectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
        ),
      ),
      dividerColor: Colors.grey.shade800,
    );
  }
}