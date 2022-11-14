import 'package:dio/dio.dart';

import '../../../res/constants.dart';
import '../dio/dio_client.dart';

class ScriptRepo {
  final _dio = DioClient.getDio();

  Future<Response> getScripts(int userId) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
    };

    return await _dio.post(ApiValues.getScripts, data: params);
  }

  Future<Response> getPreviewScript(int subjectId) async {
    final Map<String, dynamic> params = {
      "subject_id": subjectId,
    };

    return await _dio.post(ApiValues.getPreview, data: params);
  }

  Future<Response> makeScript(int userId, String authKey, int subId) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
      "auth_key": authKey,
      "subject_id": subId,
    };

    return await _dio.post(ApiValues.getPreview, data: params);
  }
}
