import "package:flutter/material.dart";
import "package:meditrack/theme/schemes/green_scheme.dart";
import "package:meditrack/theme/utils/extension.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  ThemeData get light => _theme(applicationTheme());
  ThemeData get dark => _theme(applicationTheme(isDark: true));

  ColorScheme applicationTheme({bool isDark = false}) {
    if (isDark) {
      return BlueScheme.darkBlueScheme().toColorScheme();
    }

    return BlueScheme.lightBlueScheme().toColorScheme();
  }

  ThemeData _theme(ColorScheme colorScheme) => ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      shadowColor: colorScheme.shadow,
      colorScheme: colorScheme,
      secondaryHeaderColor: colorScheme.onSecondary,
      chipTheme: _chipThemeData(colorScheme),
      checkboxTheme: _checkboxThemeData(colorScheme),
      textTheme: _textTheme(colorScheme),
      iconTheme: _iconThemeData(colorScheme),
      scaffoldBackgroundColor: colorScheme.surface,
      primaryColor: colorScheme.primary,
      dividerTheme: _dividerThemeData(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      floatingActionButtonTheme: _floatingActionButtonThemeData(colorScheme),
      cardTheme: _cardTheme(colorScheme));

  ChipThemeData _chipThemeData(ColorScheme colorScheme) => ChipThemeData(
      backgroundColor: colorScheme.tertiaryContainer.withOpacity(0.2),
      selectedColor: colorScheme.onSurfaceVariant.withOpacity(0.4),
      checkmarkColor: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outline), borderRadius: BorderRadius.circular(8.0)));

  CheckboxThemeData _checkboxThemeData(ColorScheme colorScheme) =>
      CheckboxThemeData(side: BorderSide(width: 2, color: colorScheme.outline));

  TextTheme _textTheme(ColorScheme colorScheme) =>
      textTheme.apply(bodyColor: colorScheme.onSurface, displayColor: colorScheme.onSurface);

  IconThemeData _iconThemeData(ColorScheme colorScheme) => IconThemeData(color: colorScheme.onSurface);

  DividerThemeData _dividerThemeData(ColorScheme colorScheme) => DividerThemeData(color: colorScheme.outline);

  FloatingActionButtonThemeData _floatingActionButtonThemeData(ColorScheme colorScheme) =>
      FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary, elevation: 1);
  CardTheme _cardTheme(ColorScheme colorScheme) => CardTheme(
      color: colorScheme.secondary,
      shadowColor: colorScheme.shadow.withOpacity(0.3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)));

  AppBarTheme _appBarTheme(ColorScheme colorScheme) =>
      AppBarTheme(backgroundColor: colorScheme.surface, foregroundColor: colorScheme.onSurface);

  InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) => InputDecorationTheme(
      counterStyle: const TextStyle(fontSize: 12),
      labelStyle: const TextStyle(fontSize: 12),
      floatingLabelStyle: TextStyle(color: colorScheme.surfaceContainerHighest),
      fillColor: colorScheme.onSecondary.withOpacity(0.1),
      filled: true,
      border: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.tertiaryFixed)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.tertiaryFixed)));
}
