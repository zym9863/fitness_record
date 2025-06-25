import 'package:flutter/material.dart';

class AppTheme {
  // 主色调渐变
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A78FA), Color(0xFF2D5CFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 次要色调渐变
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF5CE1E6), Color(0xFF38B7BC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 能量色调渐变 (用于卡路里等)
  static const LinearGradient energyGradient = LinearGradient(
    colors: [Color(0xFFFF8C48), Color(0xFFFF6B3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 活动色调渐变 (用于步数等)
  static const LinearGradient activityGradient = LinearGradient(
    colors: [Color(0xFF4CD964), Color(0xFF2ABD4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 卡片阴影
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 25,
      offset: const Offset(0, 10),
    ),
  ];

  // 按钮阴影
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: const Color(0xFF4A78FA).withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
  ];

  // 圆角半径
  static const double borderRadius = 16.0;
  static const double smallBorderRadius = 8.0;

  // 动画持续时间
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // 获取主题数据
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A78FA),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF2D3142),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFF2D3142)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF4A78FA),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF4A78FA),
          side: const BorderSide(color: Color(0xFF4A78FA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(smallBorderRadius),
          borderSide: const BorderSide(color: Color(0xFF4A78FA), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIconColor: const Color(0xFF4A78FA),
      ),
    );
  }
}