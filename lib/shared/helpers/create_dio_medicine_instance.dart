import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/shared/services/client_shared_preferences_interface.dart';

Dio createDioMedicineInstance(String baseUrl) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 120),
    receiveTimeout: const Duration(seconds: 120),
    contentType: 'application/json',
  ));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
    ));
  }

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final clientShared = getIt.get<IClientSharedPreferences>();
      String? token = await clientShared.get('tokenMedicine');

      if (token != null) {
        options.headers["Authorization"] = 'Token $token';
      }
      return handler.next(options);
    },
    onError: (error, handler) {
      return handler.next(error);
    },
  ));

  // Você pode adicionar interceptors, headers, etc.
  return dio;
}
