import 'package:flutter/material.dart';
import 'dart:math';

bool isTablet(BuildContext context) {
  final size = MediaQuery.of(context).size;

  // Calcular a diagonal em pixels lógicos (não precisamos dividir por devicePixelRatio)
  final diagonalInPixels = sqrt(size.width * size.width + size.height * size.height);

  // Definir a densidade de pixels da tela
  final diagonalInInches = diagonalInPixels / 160; // A densidade de pixel média de 160 ppi (pixels por polegada)

  return diagonalInInches >= 7.0;
}
