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
    return await _dio.post(ApiValues.createGroup, data: params);
  }

  Future<Response> addGroupMember(String memberId, int groupId) async {
    final Map<String, dynamic> params = {
      "user_id": memberId,
      "group_id": groupId,
    };
    return await _dio.post(ApiValues.addMember, data: params);
  }

  Future<Response> deleteGroupMember(int userId, int memberId) async {
    final Map<String, dynamic> params = {
      "member_id": memberId,
      "user_id": userId,
    };
    return await _dio.post(ApiValues.deleteMember, data: params);
  }

  Future<Response> getGroup(int userId) async {
    final Map<String, dynamic> params = {"user_id": userId};
    return await _dio.get(ApiValues.getGroupByUserId, queryParameters: params);
  }

  Future<Response> getGroupMembers(int groupId) async {
    final Map<String, dynamic> params = {"group_id": groupId};
    return await _dio.get(ApiValues.getGroupMembers, queryParameters: params);
  }
}
