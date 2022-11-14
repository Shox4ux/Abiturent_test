import 'package:dio/dio.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class SubjectRepo {
  final _dio = DioClient.getDio();

  Future<Response> getSubjects() async {
    return _dio.get(ApiValues.subjectUrl);
  }
}
