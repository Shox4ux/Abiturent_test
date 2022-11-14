import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class UserRepo {
  final _dio = DioClient.getDio();

  Future<Response> getUserRatings() async {
    return _dio.get(ApiValues.ratingUrl);
  }

  Future<Response> getUserProfile(int userId) async {
    final Map<String, dynamic> params = {"id": userId};

    return _dio.get(ApiValues.getUserProfile, queryParameters: params);
  }
}
