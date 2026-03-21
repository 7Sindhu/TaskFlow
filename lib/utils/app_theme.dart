import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.light,
        surface: const Color(0xFFF8F9FF),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF6366F1).withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6366F1));
          }
          return const TextStyle(fontSize: 11);
        }),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FF),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.dark,
        surface: const Color(0xFF0F172A),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E293B),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: const Color(0xFF1E293B),
        indicatorColor: const Color(0xFF6366F1).withOpacity(0.2),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static Color priorityColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF10B981);
      case 1:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6366F1);
    }
  }

  static Color statusColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF6B7280);
      case 1:
        return const Color(0xFF3B82F6);
      case 2:
        return const Color(0xFFF59E0B);
      case 3:
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6366F1);
    }
  }
}
