import 'package:flutter/material.dart';

ThemeData lighttheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: Colors.purple, // base seed color for harmonized palette
        primary: Colors.purple,
        tertiaryFixed: Colors.black,
        secondary: const Color.fromARGB(255, 228, 132, 8),
        surface: Colors.white,
        error: Colors.red,
        tertiaryContainer: Colors.grey[100],
      ).copyWith(
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onError: Colors.white,
        tertiary: Colors.black, // replaces your old "tertiaryFixed"
      ),
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: const TextTheme(),
);

ThemeData darktheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: Colors.purple, // base seed color for harmonized palette
        primary: Colors.purple,
        tertiaryFixed: Colors.white,
        secondary: const Color.fromARGB(255, 228, 132, 8),
        surface: Colors.black,
        error: Colors.red,
        tertiaryContainer: Colors.grey[800],
      ).copyWith(
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onError: Colors.black,
        tertiary: Colors.white, // replaces your old "tertiaryFixed"
      ),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(),
);