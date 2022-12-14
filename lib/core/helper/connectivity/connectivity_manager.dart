import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:test_app/core/helper/dio/dio_client.dart';

class ConnectivityManager {
  final _dio = DioClient.getDio();
  final _connectivity = Connectivity();
  StreamSubscription? streamSubscription;

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    final completer = Completer<Response>();
    streamSubscription =
        _connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        streamSubscription!.cancel();
        completer.complete(
          _dio.request(
            requestOptions.path,
            cancelToken: requestOptions.cancelToken,
            data: requestOptions.data,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
          ),
        );
      }
    });
    return completer.future;
  }
}
