import 'package:dio/dio.dart';

import '../../../res/constants.dart';
import '../dio/dio_client.dart';

class PaymentRepo {
  final _dio = DioClient.getDio();

  Future<Response> addCard(
      int userId, String cardPan, String cardMonth, String cardName) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "card_pan": cardPan,
      "card_month": cardMonth,
      "card_name": cardName
    });
    return await _dio.post(ApiValues.addCardUrl, data: formData);
  }

  Future<Response> deleteCard(int userId, String cardPan, int cardId) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "card_pan": cardPan,
      "card_id": cardId,
    });
    return await _dio.post(ApiValues.deleteCardUrl, data: formData);
  }

  Future<Response> getCards(int userId) async {
    var formData = FormData.fromMap({
      "user_id": userId,
    });
    return await _dio.post(ApiValues.getCardsUrl, data: formData);
  }

  Future<Response> makePayment(
      int userId, String cardPan, String amount, String cardPeriod) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "card_pan": cardPan,
      "amount": amount,
      "card_month": cardPeriod,
    });
    return await _dio.post(ApiValues.amountUrl, data: formData);
  }

  // Future<Response> getCards(int userId) async {
  //   var formData = FormData.fromMap({"user_id": userId});
  //   return await _dio.post(ApiValues.getCardsUrl, data: formData);
  // }

  Future<Response> getPaymentHistory(int userId) async {
    final Map<String, dynamic> params = {"id": userId};
    return await _dio.get(ApiValues.getHistoryUrl, queryParameters: params);
  }
}
