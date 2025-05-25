import 'package:flutter/material.dart';
// import 'package:gedocs_app/shared/components/gedocs_icons.dart';

Widget noData({String icon = 'no-data', double iconSize = 150, String label = 'Não há dados'}) {
  return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty),
          // GEDocsIcons.icon(icon, width: iconSize),
          const SizedBox(height: 20),
          Text(label),
          const SizedBox(height: 20),
        ],
      ));
}
