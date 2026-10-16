import 'package:flutter/material.dart';

/// Professional color system for StressLess app
/// Designed with Material Design 3 principles
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4B45D9);
  static const Color primaryLight = Color(0xFF9D97FF);

  // Stress Level Colors
  static const Color stressLow = Color(0xFF4CAF50); // Green
  static const Color stressMedium = Color(0xFFFFA726); // Orange
  static const Color stressHigh = Color(0xFFEF5350); // Red

  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF1A1A2E);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);
  static const Color textWhite = Colors.white;

  // Accent Colors
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDAB3D);
  static const Color error = Color(0xFFD63031);
  static const Color info = Color(0xFF0984E3);

  // UI Elements
  static const Color divider = Color(0xFFDFE6E9);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [stressLow, Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [stressMedium, Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [stressHigh, Color(0xFFC62828)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper Methods
  static Color getStressColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return stressLow;
      case 'moderate':
      case 'medium':
        return stressMedium;
      case 'high':
        return stressHigh;
      default:
        return textSecondary;
    }
  }

  static LinearGradient getStressGradient(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return successGradient;
      case 'moderate':
      case 'medium':
        return warningGradient;
      case 'high':
        return dangerGradient;
      default:
        return primaryGradient;
    }
  }
}
