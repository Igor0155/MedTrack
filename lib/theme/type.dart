import 'package:flutter/material.dart';

class MaterialScheme {
  const MaterialScheme(
      {required this.brightness, //ligth or dark
      required this.primary, // COr principal do tema (ligth or dark)
      required this.onPrimary, // texto ou ícones sobre a cor primária.
      required this.secondary, // Cor secundaria
      required this.onSecondary, // texto ou ícones sobre a Cor secundaria.
      required this.error, // cor de erro
      required this.onError, // texto ou ícones sobre a Cor erro
      required this.blueGreyLight,
      required this.tertiaryFixed, // Terceira cor
      required this.onTertiary, // texto ou ícones sobre a terceira cor
      required this.surface, // cor de fundo
      required this.onSurface, // texto ou ícones sobre a Cor de fundo
      required this.success, // cor de successo
      required this.info, // cor de informações (snackBar, icons...)
      required this.variant, // cores para textos
      required this.shadow, // cor escura (preto)
      required this.outline // cor cinza
      });

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color success;
  final Color info;
  final Color variant;
  final Color tertiaryFixed;
  final Color onTertiary;
  final Color blueGreyLight;

  final Color error;
  final Color onError;
  final Color surface;
  final Color onSurface;
  final Color outline;
  final Color shadow;
}
