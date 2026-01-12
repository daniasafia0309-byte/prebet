import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    fontFamily: 'Inter',

    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.pageColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.primaryColor),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardColor,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppColors.primaryColor),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.buttonText,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.navbarBackground,
      selectedItemColor: AppColors.navbarActive,
      unselectedItemColor: AppColors.navbarInactive,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static OutlineInputBorder _border([Color? color]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: color ?? AppColors.navbarInactive,
        ),
      );
}
