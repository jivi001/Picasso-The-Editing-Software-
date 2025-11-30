import 'package:flutter/material.dart';
import 'picasoo_colors.dart';
import 'picasoo_typography.dart';

class PicasooTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: PicasooColors.surface0,
      primaryColor: PicasooColors.primary,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: PicasooColors.primary,
        secondary: PicasooColors.secondary,
        surface: PicasooColors.surface1,
        error: PicasooColors.error,
        onPrimary: PicasooColors.textHigh,
        onSecondary: PicasooColors.textHigh,
        onSurface: PicasooColors.textMed,
        onError: PicasooColors.textHigh,
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: PicasooTypography.display,
        titleLarge: PicasooTypography.h1,
        titleMedium: PicasooTypography.h2,
        bodyMedium: PicasooTypography.body,
        bodySmall: PicasooTypography.small,
        labelLarge: PicasooTypography.button,
      ),

      // Component Themes
      iconTheme: const IconThemeData(
        color: PicasooColors.textMed,
        size: 20,
      ),

      dividerTheme: const DividerThemeData(
        color: PicasooColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
