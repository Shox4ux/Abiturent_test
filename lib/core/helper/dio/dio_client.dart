import 'package:dio/dio.dart';
import 'package:test_app/core/helper/interceptor/interceptor_to_retry.dart';
import 'package:test_app/res/constants.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiValues.baseUrl,
      ),
    );
    dio.interceptors.add(
      InterceptorToRetry(),
    );
    return dio;
  }
}
