// app_theme.dart
// app_theme.dart
// Theme ứng dụng
import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_colors.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontFamily: 'Montserrat', color: AppColors.black),
      bodyMedium: TextStyle(fontFamily: 'Montserrat', color: AppColors.black),
      titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        color: AppColors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      titleTextStyle: TextStyle(
        fontFamily: 'Montserrat',
        color: AppColors.white,
        fontSize: 20,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        textStyle: const TextStyle(fontFamily: 'Montserrat'),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primaryColor,
      secondary: AppColors.grey,
      surface: AppColors.white,
    ),
  );
}
