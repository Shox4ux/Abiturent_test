import 'package:dio/dio.dart';

import '../../../res/constants.dart';
import '../dio/dio_client.dart';

class GroupRepo {
  final _dio = DioClient.getDio();
  Future<Response> createGroup(
      int userId, int subjectId, String groupTitle) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
      "subject_id": subjectId,
      "group_title": groupTitle,
    };
    return await _dio.post(
      ApiValues.createGroup,
      queryParameters: params,
    );
  }
}
