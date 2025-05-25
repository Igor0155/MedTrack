import 'package:flutter/material.dart';

AppBar medAppBar(
    {Widget? leading,
    required String title,
    List<Widget>? actions,
    double? scrolledUnderElevation,
    PreferredSizeWidget? bottom,
    IconThemeData? iconTheme,
    Color? backgroundColor,
    Color? titleColor}) {
  return AppBar(
      backgroundColor: backgroundColor,
      bottom: bottom,
      scrolledUnderElevation: scrolledUnderElevation,
      actions: actions,
      leading: leading,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)));
}
