import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Blue used throughout the app
  static const Color primaryBlue = Color(0xFF2A64F6); // 2F6BFF alternative
  static const Color background = Color(0xFFF9FAFB); // Light gray background
  
  static const Color textDark = Color(0xFF1A1C1E);
  static const Color textLight = Color(0xFF6B7280);
  
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.inter(color: textDark, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: textDark),
        bodyMedium: GoogleFonts.inter(color: textDark),
        bodySmall: GoogleFonts.inter(color: textLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textDark,
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF3F4F6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue),
        ),
        hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
      ),
    );
  }
}
