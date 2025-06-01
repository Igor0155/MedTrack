import 'package:flutter/material.dart';
import 'package:meditrack/theme/type.dart';

class BlueScheme {
  static MaterialScheme lightBlueScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xFF25D366), // azul principal 0xFF1677FF
      onPrimary: Color(0xffFFFFFF),
      secondary: Color(0xfffafafa),
      onSecondary: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF128C7E),
      onTertiary: Color(0xFFFFFFFF),
      success: Color(0xFF66BB6A),
      info: Color(0xffE6F4FF),
      blueGreyLight: Color(0xffDAEBFF),
      variant: Color(0xff1C1C1C),
      error: Color(0xFFED4343), // vermelho de erro
      onError: Color(0xFFFFFFFF),
      surface: Color(0xffFCFDFF), // igual ao fundo
      onSurface: Color(0xff0D0D0D),
      outline: Color(0xffd1d5db), // cinza principal
      shadow: Color(0xFF000000),
    );
  }

  static MaterialScheme darkBlueScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xff426642), // azul principal
      onPrimary: Color(0xffFFFFFF), // texto escuro em fundo claro
      secondary: Color(0xff1A3746), // azul forte
      onSecondary: Color(0xffDBDBDB),
      tertiaryFixed: Color(0xFFDCF8C6),
      onTertiary: Color(0xffF7F7F7),
      info: Color(0xffE6F4FF),
      success: Color(0xFF66BB6A),
      variant: Color(0xffCEDEF2),
      error: Color(0xffED4343), // vermelho de erro
      onError: Color(0xFF0C1034),
      blueGreyLight: Color(0xffDAEBFF),
      surface: Color(0xff0B1E28), // fundo escuro para superfícies
      onSurface: Color(0xffCEDEF2), // texto claro
      outline: Color(0xFFB0B4BA), // contornos mais suaves em tons claros
      shadow: Color(0xffffffff),
    );
  }
}
