import 'package:dio/dio.dart';

import '../../../res/constants.dart';
import '../dio/dio_client.dart';

class ScriptRepo {
  final _dio = DioClient.getDio();

  Future<Response> getScripts(int userId) async {
    var formData = FormData.fromMap({"user_id": userId});
    return await _dio.post(ApiValues.getScripts, data: formData);
  }

  Future<Response> getPreviewScript(int subjectId) async {
    var formData = FormData.fromMap({"subject_id": subjectId});
    return await _dio.post(ApiValues.getPreview, data: formData);
  }

  Future<Response> makeScript(int userId, String authKey, int subId) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "auth_key": authKey,
      "subject_id": subId,
    });
    return await _dio.post(ApiValues.makeScript, data: formData);
  }
}
