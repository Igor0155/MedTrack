import 'package:flutter/material.dart';

Widget backgroundAndLogo({required String urlLogo, isMaxHeight = false}) {
  return Builder(builder: (context) {
    return Container(
      width: double.infinity,
      height: isMaxHeight ? double.infinity : 320,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: isMaxHeight
              ? null
              : const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (urlLogo.isEmpty)
            CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary)
          else
            Image.network(urlLogo,
                height: isMaxHeight ? 50 : 80,
                loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                    ? child
                    : CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary)),
        ],
      ),
    );
  });
}
