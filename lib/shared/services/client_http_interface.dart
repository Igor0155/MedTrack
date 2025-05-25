import 'package:dio/dio.dart';
import 'package:test/expect.dart';

typedef ClientHttpException = DioException;

class ClientHttpResponse {
  final Map<String, dynamic> data;
  final int statusCode;
  final bool isSuccess;

  ClientHttpResponse(
      {required this.data, required this.statusCode, required this.isSuccess});

  factory ClientHttpResponse.build(Response<dynamic> response) {
    return ClientHttpResponse(
      data: response.data ??= <String, dynamic>{},
      statusCode: response.statusCode ?? 500,
      isSuccess: true,
    );
  }

  factory ClientHttpResponse.buildFromException(Object e) {
    var statusCode = 500;

    var body = <String, dynamic>{};
    body["data"] = <String, dynamic>{};
    body["message"] = "Ocorreu um erro ao tentar acessar o servidor.";
    body["status"] = "error";

    if (e is ClientHttpException) {
      statusCode = e.response?.statusCode ?? 500;
      body["data"] = e.response?.data;
      body["message"] = e.response?.data != null &&
              e.response?.data != isEmpty &&
              e.response?.data != ""
          ? e.response?.data[1] == isEmpty
              ? body["message"]
              : e.response?.data['message']
          : body["message"];

      // body["message"] = e.response?.data?.message;
    }

    return ClientHttpResponse(
        data: body, statusCode: statusCode, isSuccess: false);
  }
}

abstract class IClientHttp {
  Future<ClientHttpResponse> get(String url);
  Future<ClientHttpResponse> post(String url, Map<String, dynamic> data);
  Future<ClientHttpResponse> put(String url, Map<String, dynamic> data);
  Future<ClientHttpResponse> patch(String url, [Map<String, dynamic>? data]);
  Future<ClientHttpResponse> delete(String url);
  Future<ClientHttpResponse> uploadFile(
      String url, FormData data, Options options);
}
