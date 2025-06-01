import 'package:flutter/material.dart';
import 'package:meditrack/shared/custom_clipper/custom_clipper.dart';

Widget bottomClipper() {
  return Builder(builder: (context) {
    return Stack(children: [
      Align(
          alignment: Alignment.bottomCenter,
          child: Transform.rotate(
              angle: 3.14,
              child: ClipPath(
                  clipper: MyCustomClipper(waveDeep: 15, waveDeep2: 25),
                  child: Container(height: 75, color: Theme.of(context).colorScheme.primary.withOpacity(.6))))),
      Align(
          alignment: Alignment.bottomCenter,
          child: Transform.rotate(
              angle: 3.14,
              child: ClipPath(
                  clipper: MyCustomClipper(waveDeep: 25, waveDeep2: 19),
                  child: Container(height: 75, color: Theme.of(context).colorScheme.primary.withOpacity(.5))))),
      Align(
          alignment: Alignment.bottomCenter,
          child: Transform.rotate(
              angle: 3.14,
              child: ClipPath(
                  clipper: MyCustomClipper(waveDeep: 28, waveDeep2: 9),
                  child: Container(height: 70, color: Theme.of(context).colorScheme.primary.withOpacity(.6)))))
    ]);
  });
}
