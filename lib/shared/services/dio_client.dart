import 'package:dio/dio.dart';
import 'package:meditrack/shared/types/exception_type.dart';

class DioClient {
  final Dio _dio = Dio();

  Future<bool> download(String uri, dynamic savePath,
      void Function(int, int)? onReceiveProgress) async {
    var response = await _dio.download(uri, savePath,
        onReceiveProgress: onReceiveProgress);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw MediTrackException(response.data['message']);
    }
  }
}
