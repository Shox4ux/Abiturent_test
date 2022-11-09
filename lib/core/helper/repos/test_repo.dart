import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class TestRepo {
  final _dio = DioClient.getDio();

  Future<Response> getTestsBySubjectId(int subjectId, int typeIndex) async {
    final Map<String, dynamic> params = {
      "id": subjectId,
      "type": typeIndex,
    };
    return await _dio.get(ApiValues.testsBySubIdAndTypeIndex,
        queryParameters: params);
  }

  Future<Response> getInnerTestList(int testId) async {
    final Map<String, dynamic> params = {"id": testId};

    return await _dio.get(ApiValues.innerTest, queryParameters: params);
  }

  Future<Response> getTestById(
    int testId,
    int userId,
  ) async {
    final Map<String, dynamic> params = {"user_id": userId, "id": testId};

    return await _dio.get(ApiValues.innerTest, queryParameters: params);
  }
}
