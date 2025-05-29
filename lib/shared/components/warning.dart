import 'package:flutter/material.dart';

Widget warning({required String label, required Function() fun}) {
  return Builder(builder: (context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.warning, size: 150), //GEDocsIcons.icon('warning', width: 150),
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))),
          const SizedBox(height: 20),
          IconButton(
            onPressed: () {
              fun();
            },
            icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor, size: 20),
            style: ElevatedButton.styleFrom(
                side: BorderSide(style: BorderStyle.solid, width: 2, color: Theme.of(context).primaryColor),
                backgroundColor: Theme.of(context).colorScheme.surface),
          )
        ],
      ),
    );
  });
}
