import 'package:flutter/material.dart';


class DarkColors {
  static const background = Color(0xFF1E1E1E);                  // Fondo general
  static const primary = Color(0xFF424242);                     // Superficies (AppBar, etc.)
  static const secondary = Color(0xFFFFFFFF);                   // Texto principal
  static const highlight = Color(0xFFB71C1C);                   // Color de énfasis (Botones, etc.)
  static const tertiary = Color.fromRGBO(255, 255, 255, 0.7);  // Texto secundario
}


class DarkTheme {

  static final ColorScheme darkColorScheme = ColorScheme.dark(
    background: DarkColors.background,
    surface: DarkColors.primary,
    primary: DarkColors.highlight,
    secondary: DarkColors.secondary,
    tertiary: DarkColors.tertiary,
  );

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.background,

    primaryColor: darkColorScheme.primary,  // No se usa mucho en Material3 pero lo ponemos por si acaso

    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.secondary,
      iconTheme: IconThemeData(color: darkColorScheme.secondary),
      titleTextStyle: TextStyle(
        color: darkColorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 30,
        fontFamily: 'Pokemon',
      ),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: darkColorScheme.secondary),
      bodyMedium: TextStyle(color: darkColorScheme.tertiary),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: darkColorScheme.surface,
      selectedColor: darkColorScheme.primary,
      labelStyle: TextStyle(color: darkColorScheme.secondary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surface,
      labelStyle: TextStyle(color: darkColorScheme.secondary),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: darkColorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
