import 'package:dio/dio.dart';

import '../dio/dio_client.dart';

class NewsRepository {
  final _dio = DioClient.getDio();

  Future<Response> getAllNews() async {
    return await _dio.get("/news/index");
  }

  Future<Response> getNewsWithPagination(
      {required int page, required int perPage}) async {
    final Map<String, dynamic> params = {"page": page, "per-page": perPage};
    return await _dio.get("news/index", queryParameters: params);
  }

  Future<Response> getNewsById({required int newsId}) async {
    final Map<String, dynamic> params = {"id": newsId};
    return await _dio.get("news/index", queryParameters: params);
  }
}
