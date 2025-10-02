
import 'package:flutter/material.dart';

class AppColors {
  // Light mode
  static const background = Color(0xFFFFFFFF);
  static const foreground = Color(0xFF1A1A1A);
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF1A1A1A);
  static const popover = Color(0xFFFFFFFF);
  static const popoverForeground = Color(0xFF1A1A1A);
  static const primary = Color(0xFF00796B);
  static const primaryForeground = Color(0xFFFFFFFF);
  static const secondary = Color(0xFFF0FDF4);
  static const secondaryForeground = Color(0xFF00796B);
  static const muted = Color(0xFFF8F9FA);
  static const mutedForeground = Color(0xFF6C757D);
  static const accent = Color(0xFFE8F5E8);
  static const accentForeground = Color(0xFF00796B);
  static const destructive = Color(0xFFDC2626);
  static const destructiveForeground = Color(0xFFFFFFFF);
  static const border = Color.fromRGBO(0, 0, 0, 0.1);
  static const inputBackground = Color(0xFFFFFFFF);
  static const switchBackground = Color(0xFFE2E8F0);

  // Dark mode
  static const darkBackground = Color(0xFF0A0A0A);
  static const darkForeground = Color(0xFFFAFAFA);
  static const darkCard = Color(0xFF111111);
  static const darkCardForeground = Color(0xFFFAFAFA);
  static const darkPrimary = Color(0xFF26A69A);
  static const darkPrimaryForeground = Color(0xFF0F0F0F);
  static const darkSecondary = Color(0xFF1A1A1A);
  static const darkSecondaryForeground = Color(0xFFFAFAFA);
  static const darkMuted = Color(0xFF1F1F1F);
  static const darkMutedForeground = Color(0xFFA3A3A3);
  static const darkAccent = Color(0xFF1F1F1F);
  static const darkAccentForeground = Color(0xFFFAFAFA);
  static const darkDestructive = Color(0xFFEF4444);
  static const darkDestructiveForeground = Color(0xFFFAFAFA);
  static const darkBorder = Color.fromRGBO(255, 255, 255, 0.1);
  static const darkInputBackground = Color(0xFF1A1A1A);
  static const darkSwitchBackground = Color(0xFF2A2A2A);
}

class AppFonts {
  static const poppins = 'Poppins';
  static const inter = 'Inter';
}

class AppRadius {
  static const sm = 8.0;   // var(--radius-sm)
  static const md = 10.0;  // var(--radius-md)
  static const lg = 12.5;  // var(--radius-lg)
  static const xl = 16.5;  // var(--radius-xl)
}

LinearGradient appGradient({bool isDark = false}) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: isDark
        ? [
            const Color(0xFF0F0F23),
            const Color(0xFF1E1B31),
            const Color(0xFF312E81)
          ]
        : [
            const Color(0xFFF1F5F9),
            const Color(0xFFE0E7FF),
            const Color(0xFFC7D2FE)
          ],
  );
}
