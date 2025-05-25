import 'package:flutter/material.dart';
import 'package:meditrack/screens/auth/components/background_and_logo.dart';

// Função que retorna o widget comum para a tela de login
Widget commomWidget(
    {required Widget child, required Key formKey, required String? logoUrl, bool fixedSizedAndMaxHeight = false}) {
  return Builder(builder: (context) {
    return Form(
        key: formKey,
        child: Container(
            constraints: fixedSizedAndMaxHeight ? null : BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            height: fixedSizedAndMaxHeight ? MediaQuery.of(context).size.height : null,
            child: Stack(children: [backgroundAndLogo(isMaxHeight: fixedSizedAndMaxHeight), child])));
  });
}
