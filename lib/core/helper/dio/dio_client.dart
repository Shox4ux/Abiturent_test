import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiValues.baseUrl,
      ),
    );

    return dio;
  }
}
