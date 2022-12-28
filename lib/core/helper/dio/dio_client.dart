import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:test_app/res/constants.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiValues.baseUrl,
      ),
    );
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: (message) => print(message),
      retries: 1,
      retryDelays: const [
        Duration(seconds: 1),
      ],
    ));
    return dio;
  }
}
