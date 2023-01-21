import 'package:dio/dio.dart';

class BadRequestException extends DioError {
  BadRequestException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);
  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);
  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
