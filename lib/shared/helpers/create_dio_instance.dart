import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio createDioInstance(String baseUrl) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
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
      // final clientShared = getIt.get<IClientSharedPreferences>();
      // String? token = await clientShared.get('token');

      // if (token != null) {
      //   options.headers["Authorization"] = token;
      // }
      return handler.next(options);
    },
    onError: (error, handler) {
      return handler.next(error);
    },
  ));

  return dio;
}
