import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test_app/core/helper/connectivity/connectivity_manager.dart';

class InterceptorToRetry extends Interceptor {
  final _connectivityManager = ConnectivityManager();
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        return _connectivityManager.scheduleRequestRetry(err.requestOptions);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other &&
        err.error != null &&
        err.error is SocketException;
  }
}
