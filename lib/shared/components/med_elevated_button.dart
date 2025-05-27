import 'package:flutter/material.dart';
import 'package:meditrack/theme/utils/app_colors.dart';

class MedElevatedButton {
  static Widget primary({
    required String label,
    void Function()? onPressed,
    Widget? child,
    Key? key,
    double? elevation,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity,
  }) {
    return Builder(builder: (context) {
      return ElevatedButton(
          key: key,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            visualDensity: visualDensity,
            elevation: elevation,
            shadowColor: elevation != null ? Colors.transparent : null,
            padding: padding,
            side: BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).colorScheme.primary),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: fontSize ?? 14),
          ),
          child: child ??
              Text(label,
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)));
    });
  }

  static Widget primaryIcon({
    required String label,
    required IconData? icon,
    void Function()? onPressed,
    Key? key,
    BorderSide? side,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity,
  }) {
    return Builder(builder: (context) {
      side ??= BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).colorScheme.primary);
      return ElevatedButton.icon(
          key: key,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            visualDensity: visualDensity,
            padding: padding,
            side: side,
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: fontSize ?? 14),
          ),
          icon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary, size: 20),
          label: Text(label,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)));
    });
  }

  // Botão primario com a cor primaria do tema mas sem fundo
  static Widget primaryOutline({
    required String label,
    void Function()? onPressed,
    BorderSide? side,
    Widget? child,
    Key? key,
    double? fontSize,
    Color? color,
    double? elevation,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity,
  }) {
    return Builder(builder: (context) {
      side ??= BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).colorScheme.primary);
      color ??= Theme.of(context).colorScheme.primary;
      return ElevatedButton(
          key: key,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            visualDensity: visualDensity,
            padding: padding,
            shadowColor: elevation != null ? Colors.transparent : null,
            side: side,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: fontSize ?? 14),
          ),
          child: child ?? Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)));
    });
  }

  // Botão secundário Todo preenchido de vermelho
  static Widget secondary({
    required String label,
    void Function()? onPressed,
    Key? key,
    double? fontSize,
    EdgeInsetsGeometry? padding,
  }) {
    return Builder(builder: (context) {
      return ElevatedButton(
          key: key,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            side: BorderSide(style: BorderStyle.solid, width: 1, color: AppColors.redError),
            backgroundColor: AppColors.redError,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: fontSize ?? 14),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
    });
  }

// Botão secondario sem preenchimento só com texto e bordas em vermelho
  static Widget secondaryOutline({
    required String label,
    void Function()? onPressed,
    Key? key,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity,
  }) {
    return Builder(builder: (context) {
      return ElevatedButton(
          key: key,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            visualDensity: visualDensity,
            padding: padding,
            side: BorderSide(style: BorderStyle.solid, width: 1, color: AppColors.redError),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: fontSize ?? 14),
          ),
          child: Text(label, style: TextStyle(color: AppColors.redError)));
    });
  }

  static Widget secondaryOutlineIcon({
    required String label,
    required IconData? icon,
    void Function()? onPressed,
    Key? key,
    double? fontSize,
    EdgeInsetsGeometry? padding,
  }) {
    return Builder(builder: (context) {
      return ElevatedButton.icon(
          key: key,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            side: BorderSide(style: BorderStyle.solid, width: 1, color: AppColors.redError),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: fontSize ?? 14),
          ),
          icon: Icon(icon, color: AppColors.redError, size: 20),
          label: Text(label, style: TextStyle(color: AppColors.redError)));
    });
  }

// Botão sem preenchimento só com texto e bordas em cinzas
  static Widget tertiaryBasic({
    required String label,
    void Function()? onPressed,
    Key? key,
    double? fontSize,
    EdgeInsetsGeometry? padding,
  }) {
    return Builder(builder: (context) {
      return ElevatedButton(
          key: key,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: padding,
            side: const BorderSide(style: BorderStyle.solid, width: 1, color: Color(0xFF303030)),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            textStyle: TextStyle(fontSize: fontSize ?? 14),
          ),
          child: Text(label,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)));
    });
  }
}
