import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_app/res/constants.dart';

import 'custom_exceptions.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(BaseOptions(baseUrl: ApiValues.baseUrl));

    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) => print(message),
      ),
    );

    if (dio.interceptors.length == 1) {
      dio.interceptors.add(
        (InterceptorsWrapper(
          onError: (error, handler) async {
            debugPrint("ON ERROR GA KIRDI");
            switch (error.type) {
              case DioErrorType.connectTimeout:
              case DioErrorType.sendTimeout:
              case DioErrorType.receiveTimeout:
                throw DeadlineExceededException(error.requestOptions);
              case DioErrorType.response:
                switch (error.response?.statusCode) {
                  case 400:
                    throw BadRequestException(error.response?.data['message']);
                  case 401:
                    throw UnauthorizedException(error.requestOptions);
                  case 404:
                    throw NotFoundException(error.requestOptions);
                  case 409:
                    throw ConflictException(error.requestOptions);
                  case 422:
                    debugPrint(error.response?.data ?? "Tizimda nosozlik");
                    break;
                  case 500:
                    throw InternalServerErrorException(error.requestOptions);
                }
                break;
              case DioErrorType.cancel:
                break;
              case DioErrorType.other:
                throw NoInternetConnectionException(error.requestOptions);
            }
            debugPrint('Error Status Code:${error.response?.statusCode}');
            return handler.next(error);
          },
          onRequest: (requestOptions, handler) {
            debugPrint("ON REQUEST GA KIRDI");
            requestOptions.headers["Accept"] = "application/json";
            return handler.next(requestOptions);
          },
          onResponse: (response, handler) async {
            debugPrint("ON RESPONSE GA KIRDI");
            return handler.next(response);
          },
        )),
      );
    }

    return dio;
  }

  // Future _init() async {
  //   dio.interceptors.add(
  //     (InterceptorsWrapper(
  //       onError: (error, handler) async {
  //         debugPrint("ON ERROR GA KIRDI");
  //         switch (error.type) {
  //           case DioErrorType.connectTimeout:
  //           case DioErrorType.sendTimeout:
  //           case DioErrorType.receiveTimeout:
  //             throw DeadlineExceededException(error.requestOptions);
  //           case DioErrorType.response:
  //             switch (error.response?.statusCode) {
  //               case 400:
  //                 throw BadRequestException(error.response?.data['message']);
  //               case 401:
  //                 throw UnauthorizedException(error.requestOptions);
  //               case 404:
  //                 throw NotFoundException(error.requestOptions);
  //               case 409:
  //                 throw ConflictException(error.requestOptions);
  //               case 422:
  //                 showToast(error.response?.data ?? "Tizimda nosozlik");
  //                 break;
  //               case 500:
  //                 throw InternalServerErrorException(error.requestOptions);
  //             }
  //             break;
  //           case DioErrorType.cancel:
  //             break;
  //           case DioErrorType.other:
  //             throw NoInternetConnectionException(error.requestOptions);
  //         }
  //         debugPrint('Error Status Code:${error.response?.statusCode}');
  //         return handler.next(error);
  //       },
  //       onRequest: (requestOptions, handler) {
  //         debugPrint("ON REQUEST GA KIRDI");
  //         requestOptions.headers["Accept"] = "application/json";
  //         return handler.next(requestOptions);
  //       },
  //       onResponse: (response, handler) async {
  //         debugPrint("ON RESPONSE GA KIRDI");
  //         return handler.next(response);
  //       },
  //     )),
  //   );
  // }
}
