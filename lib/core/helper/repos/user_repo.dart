import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class UserRepo {
  final _dio = DioClient.getDio();

  Future<Response> getUsersRatings(int subId) async {
    var formData = FormData.fromMap({"subject_id": subId});
    return _dio.post(ApiValues.ratingUrl, data: formData);
  }

  Future<Response> getUserRatingBySubject(int subId, int userId) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "subject_id": subId,
    });
    return _dio.post(ApiValues.ratingUrlBySubjectId, data: formData);
  }

  Future<Response> getStats(int userId) async {
    var formData = FormData.fromMap({"user_id": userId});
    return _dio.post(ApiValues.stats, data: formData);
  }

  Future<Response> getUserProfile(int userId) async {
    final Map<String, dynamic> params = {"id": userId};
    return _dio.get(ApiValues.getUserProfile, queryParameters: params);
  }

  Future<Response> updateProfil(
    String fullName,
    int userId,
    String avatar,
    String authKey,
  ) async {
    var formData = FormData.fromMap({
      "fullname": fullName,
      "user_id": userId,
      "avatar": avatar,
      "auth_key": authKey,
    });

    return _dio.post(ApiValues.updateProfileUrl, data: formData);
  }
}
