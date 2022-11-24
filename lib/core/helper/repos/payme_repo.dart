import 'package:dio/dio.dart';

import '../../../res/constants.dart';
import '../dio/dio_client.dart';

class PaymentRepo {
  final _dio = DioClient.getDio();

  Future<Response> addCard(int userId, String cardPan, String cardMonth) async {
    var formData = FormData.fromMap(
        {"user_id": userId, "card_pan": cardPan, "card_month": cardMonth});
    return await _dio.post(ApiValues.addCardUrl, data: formData);
  }

  Future<Response> makePayment(int userId, int cardId, int amount) async {
    var formData = FormData.fromMap(
        {"user_id": userId, "card_id": cardId, "amount": amount});
    return await _dio.post(ApiValues.amountUrl, data: formData);
  }

  Future<Response> getCards(int userId) async {
    var formData = FormData.fromMap({"user_id": userId});
    return await _dio.post(ApiValues.getCardsUrl, data: formData);
  }

  Future<Response> getPaymentHistory(int userId) async {
    final Map<String, dynamic> params = {"id": userId};
    return await _dio.get(ApiValues.getHistoryUrl, queryParameters: params);
  }
}
