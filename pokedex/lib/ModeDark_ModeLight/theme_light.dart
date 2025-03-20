import 'package:flutter/material.dart';


class LightColors {
  static const background = Color(0xFFFFFBFA);  // Ejemplo, cámbialo si quieres
  static const primary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF000000);
  static const highlight = Color(0xFFD32F2F);
  static const tertiary = Color(0xFF332E2E);
}

class LightTheme {

  static final ColorScheme lightColorScheme = ColorScheme.light(
    background: LightColors.background,
    surface: LightColors.primary,
    primary: LightColors.highlight,
    secondary: LightColors.secondary,
    tertiary: LightColors.tertiary,
  );

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.background,


    primaryColor: lightColorScheme.primary,

    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.secondary,
      iconTheme: IconThemeData(color: lightColorScheme.secondary),
      titleTextStyle: TextStyle(
        color: lightColorScheme.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 30,
        fontFamily: 'Pokemon',
      ),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: lightColorScheme.secondary),
      bodyMedium: TextStyle(color: lightColorScheme.tertiary),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[300]!,
      selectedColor: lightColorScheme.primary,
      labelStyle: TextStyle(color: lightColorScheme.secondary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.surface,
      labelStyle: TextStyle(color: lightColorScheme.secondary),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: lightColorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}