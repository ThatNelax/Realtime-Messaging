import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  textTheme: GoogleFonts.rubikTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1E1E2C),
    onSurface: Color(0xFFE2E2E2),
    primary: Color(0xFF5C9DFF),
    onPrimary: Color(0xFF0D1B2A), 
    primaryContainer: Color(0xFF223A5E), 
    onPrimaryContainer: Color(0xFFD2E4FF),
    secondary: Color(0xFF00D1C1),
    onSecondary: Color(0xFF00332E),
    outline: Color(0xFF8F9BB3),
    surfaceContainer: Color(0xFF2D2D44),
    error: Color(0xFFCF6679),
  ),
);

ThemeData lightMode = ThemeData(
  textTheme: GoogleFonts.rubikTextTheme().apply(
    bodyColor: const Color(0xFF4A453E),
    displayColor: const Color(0xFF4A453E),
  ),
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFF9F8F6),
    onSurface: Color(0xFF4A453E),
    primary: Color(0xFFC9B59C),
    onPrimary: Color(0xFF2E2B26),
    secondary: Color(0xFFD9CFC7),
    onSecondary: Color(0xFF2E2B26),
    tertiary: Color(0xFFEFE9E3),
    onTertiary: Color(0xFF2E2B26),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    outline: Color(0xFF857E76),
  ),
);