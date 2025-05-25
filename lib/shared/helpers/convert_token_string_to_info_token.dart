import 'dart:convert';
import 'dart:typed_data';

import 'package:meditrack/shared/types/exception_type.dart';
import 'package:meditrack/shared/types/info_token_type.dart';

InfoToken? convertTokenStringToInfoToken(String tokenString) {
  List<String> tokenParts = tokenString.split(".");

  if (tokenParts.length != 3) {
    MediTrackException("Token inválido");
  }

  String payload = tokenParts[1];

  String normalizedPayload = base64.normalize(payload);
  Uint8List decodedBytes = base64.decode(normalizedPayload);
  String decodedString = utf8.decode(decodedBytes);

  Map<String, dynamic> decodedPayload = jsonDecode(decodedString);

  InfoToken infoToken = InfoToken.fromJson(decodedPayload);

  return infoToken;
}
