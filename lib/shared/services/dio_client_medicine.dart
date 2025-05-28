import 'package:dio/dio.dart';
import 'package:meditrack/shared/types/exception_type.dart';

class DioClientMedicine {
  final Dio _dio;

  DioClientMedicine(this._dio);

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      var response = await _dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw MedTrackException(response.data['message']);
      }
    } on DioException catch (e) {
      throw MedTrackException(e.message ?? 'Erro desconhecido ao realizar GET');
    }
  }

  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    try {
      var response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw MedTrackException(response.data['message']);
      }
    } on DioException catch (e) {
      throw MedTrackException(e.message ?? 'Erro desconhecido ao realizar POST');
    }
  }

  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(url, data: data);
    } on DioException catch (e) {
      throw MedTrackException(e.message ?? 'Erro desconhecido ao realizar PUT');
    }
  }

  Future<bool> download(String uri,
      {required dynamic savePath, void Function(int, int)? onReceiveProgress, CancelToken? cancelToken}) async {
    try {
      var response = await _dio.download(uri, savePath, onReceiveProgress: onReceiveProgress, cancelToken: cancelToken);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw MedTrackException(response.data['message']);
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        // Tratamento específico para cancelamento de download cancelado pelo usuário
        throw MedTrackException("Operação realizada pelo usuário.");
      }
      // Repassa outras exceções
      rethrow;
    }
  }
}
