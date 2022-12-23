import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class SubjectRepo {
  final _dio = DioClient.getDio();

  Future<Response> getSubjects() async {
    return _dio.get(ApiValues.subjectUrl);
  }
}
