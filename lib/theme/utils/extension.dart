import 'package:flutter/material.dart';
import 'package:meditrack/theme/type.dart';

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      surface: surface,
      tertiaryFixed: tertiaryFixed,
      onTertiary: onTertiary,
      surfaceContainerHighest: variant,
      onSurface: onSurface,
      shadow: shadow,
      error: error,
      onSecondaryFixed: blueGreyLight,
      onError: onError,
      outline: outline,
      tertiaryContainer: info,
      tertiary: success,
    );
  }
}
