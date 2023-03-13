import 'package:flutter/material.dart';

final _theme = ThemeData(
  primaryColor: const Color(0xFF007FFF),
  hoverColor: const Color(0xFF49A4FF),
  useMaterial3: true,
  fontFamily: 'Poppins',
);

class AppTheme {
  static TextTheme txtTheme = _theme.textTheme.copyWith(
    labelMedium: _theme.textTheme.labelMedium?.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w300,
    ),
    bodyMedium: _theme.textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: _theme.textTheme.bodySmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: Colors.white60,
    ),
    titleLarge: _theme.textTheme.titleMedium?.copyWith(
      fontSize: 26,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: _theme.textTheme.titleMedium?.copyWith(
      fontSize: 20,
      color: _theme.primaryColor,
    ),
    titleSmall: _theme.textTheme.titleSmall?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    displaySmall: _theme.textTheme.displayMedium?.copyWith(
      fontSize: 42,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: _theme.textTheme.headlineMedium?.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      color: Colors.white38,
    ),
    headlineSmall: _theme.textTheme.headlineSmall?.copyWith(
      fontSize: 30,
      fontWeight: FontWeight.w500,
      color: Colors.white12,
    ),
  );

  static ThemeData dark = _theme.copyWith(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      secondary: Colors.white54,
      tertiary: Colors.white24,
      background: Color(0XFF191919),
      onBackground: Colors.white,
      primaryContainer: Color(0xFF414141),
      secondaryContainer: Color(0xFF333333),
    ),
    textTheme: txtTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    canvasColor: Color(0xFF363636),
    backgroundColor: Color(0XFF191919),
    scaffoldBackgroundColor: Color(0xFF2C2C2C),
    iconTheme: IconThemeData(color: Colors.white, size: 18),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Color(0xFFC0C0C0),
        primary: _theme.colorScheme.primaryContainer,
        side: BorderSide(color: Color(0xFF575757), width: .5),
        shape: CircleBorder(),
        padding: EdgeInsets.all(2),
        textStyle: _theme.textTheme.bodyMedium,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: _theme.primaryColor,
        side: BorderSide(color: Color(0xFF575757), width: .5),
        shape: CircleBorder(),
        padding: EdgeInsets.all(10),
      ),
    ),
  );
}
