import 'package:dio/dio.dart';

import '../dio/dio_client.dart';

class NewsRepository {
  final _dio = DioClient.getDio();

  Future<Response> getMainNews() async {
    return await _dio.get("/news/index");
  }

  Future<Response> getNewsWithPagination(int page, int perPage) async {
    final Map<String, dynamic> params = {
      "page": page,
      "per-page": perPage,
    };
    return await _dio.get("news/index", queryParameters: params);
  }

  Future<Response> getNewsById(int newsId) async {
    final Map<String, dynamic> params = {
      "id": newsId,
    };
    return await _dio.get("news/index", queryParameters: params);
  }
}
