import 'package:dio/dio.dart';

class WebService {
  final _dio = Dio();

  Future<dynamic> get(
    Map<String, dynamic>? queryParameters, {
    required String url,
  }) async {
    try {
      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        return e.message;
      }
    }
  }
}
