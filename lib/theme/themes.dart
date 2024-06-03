import 'package:flutter/material.dart';
import 'package:quiz_app/theme/colors.dart';

class Themes {
  static ThemeData getLightTheme() {
    return ThemeData(
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 30),
        labelMedium: TextStyle(fontSize: 24),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.blue,
        onPrimary: Colors.white,
        secondary: AppColors.red,
        error: Color(0xFDFF0000),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        toolbarHeight: 56,
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
      ),
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: AppColors.blue),
      inputDecorationTheme: const InputDecorationTheme(
        iconColor: AppColors.blue,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
          // borderSide: BorderSide(color: Colors.white60),
        ),
        suffixIconColor: AppColors.blue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue,
          elevation: 2,
          foregroundColor: AppColors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // <-- Radius
            // side: BorderSide(width: UiSizes.width_1, color: Colors.black),
          ),
          minimumSize: const Size.fromHeight(45), // NEW
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.bgBlackColor,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.red,
        secondary: AppColors.blue,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        surface: Color.fromRGBO(17, 17, 20, 1),
        onSurface: AppColors.neutralGrey,
        error: Color(0xFDFF0000),
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(fontSize: 30),
        labelLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 18),
        bodyLarge: TextStyle(fontSize: 20),
        labelMedium: TextStyle(fontSize: 18),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: AppColors.red,
        toolbarHeight: 56,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: AppColors.red, fontWeight: FontWeight.w500, fontSize: 24),
      ),
      iconTheme: const IconThemeData(color: AppColors.red),
      inputDecorationTheme: const InputDecorationTheme(
        iconColor: AppColors.red,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.red, width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white60),
        ),
        suffixIconColor: AppColors.red,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
              side: BorderSide(width: 1, color: Colors.grey[800]!)),
          minimumSize: const Size.fromHeight(45), // NEW
        ),
      ),
    );
  }
}
