import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class UserRepo {
  final _dio = DioClient.getDio();

  Future<Response> getUserRatings() async {
    return _dio.get(ApiValues.ratingUrl);
  }
}
