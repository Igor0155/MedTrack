import 'package:dio/dio.dart';
import 'package:meditrack/shared/services/client_http_interface.dart';

class DioClientHttp implements IClientHttp {
  final Dio _dio;

  DioClientHttp(this._dio);

  @override
  Future<ClientHttpResponse> get(String url) async {
    try {
      return ClientHttpResponse.build(await _dio.get(url));
    } catch (e) {
      return ClientHttpResponse.buildFromException(e);
    }
  }

  @override
  Future<ClientHttpResponse> post(String url, Map<String, dynamic> data) async {
    try {
      return ClientHttpResponse.build(await _dio.post(url, data: data));
    } catch (e) {
      return ClientHttpResponse.buildFromException(e);
    }
  }

  @override
  Future<ClientHttpResponse> uploadFile(
      String url, FormData data, Options options) async {
    try {
      return ClientHttpResponse.build(await _dio.post(url, data: data));
    } catch (e) {
      return ClientHttpResponse.buildFromException(e);
    }
  }

  @override
  Future<ClientHttpResponse> patch(String url,
      [Map<String, dynamic>? data]) async {
    try {
      Response response;
      if (data != null) {
        response = await _dio.patch(url, data: data);
      } else {
        response = await _dio.patch(url);
      }
      return ClientHttpResponse.build(response);
    } catch (e) {
      return ClientHttpResponse.buildFromException(e);
    }
  }

  @override
  Future<ClientHttpResponse> put(String url, Map<String, dynamic> data) async {
    try {
      return ClientHttpResponse.build(await _dio.put(url, data: data));
    } catch (e) {
      return ClientHttpResponse.buildFromException(e);
    }
  }

  @override
  Future<ClientHttpResponse> delete(String url) async {
    try {
      return ClientHttpResponse.build(await _dio.delete(url));
    } catch (e) {
      return ClientHttpResponse.buildFromException(e);
    }
  }
}
