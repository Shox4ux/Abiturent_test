import 'package:dio/dio.dart';
import 'package:test_app/res/components/custom_appbar.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class UserRepo {
  final _dio = DioClient.getDio();

  Future<Response> getUsersRatings(int subId) async {
    final Map<String, dynamic> params = {"subject_id": subId};
    return _dio.post(ApiValues.ratingUrl, data: params);
  }

  Future<Response> getUserRatingBySubject(int subId, int userId) async {
    final Map<String, dynamic> params = {
      "subject_id": subId,
      "user_id": userId,
    };
    return _dio.post(ApiValues.ratingUrlBySubjectId, data: params);
  }

  Future<Response> getUserProfile(int userId) async {
    final Map<String, dynamic> params = {"id": userId};

    return _dio.get(ApiValues.getUserProfile, queryParameters: params);
  }
}
