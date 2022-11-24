import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class TestRepo {
  final _dio = DioClient.getDio();

  Future<Response> getTestsBySubjectId(int subjectId, int typeIndex) async {
    final Map<String, dynamic> params = {"id": subjectId, "type": typeIndex};
    return await _dio.get(ApiValues.testsBySubIdAndTypeIndex,
        queryParameters: params);
  }

  Future<Response> getInnerTestList(int testId) async {
    final Map<String, dynamic> params = {"id": testId};
    return await _dio.get(ApiValues.innerTest, queryParameters: params);
  }

  Future<Response> getTestById(int testId, int userId) async {
    var formData = FormData.fromMap({"test_id": testId, "user_id": userId});
    return await _dio.post(ApiValues.innerTest, data: formData);
  }

  Future<Response> sendTestAnswer(
      int questionId, int answerId, int userId, int testListId) async {
    var formData = FormData.fromMap({
      "question_id": questionId,
      "answer_id": answerId,
      "user_id": userId,
      "test_list_id": testListId,
    });
    return await _dio.post(ApiValues.sendTestAnswerUrl, data: formData);
  }

  Future<Response> getResults(int userId, int testListId) async {
    var formData =
        FormData.fromMap({"user_id": userId, "test_list_id": testListId});
    return await _dio.post(ApiValues.getResults, data: formData);
  }

  Future<Response> getErrorList(int userId) async {
    var formData = FormData.fromMap({"user_id": userId});
    return await _dio.post(ApiValues.getErrorListUrl, data: formData);
  }
}
