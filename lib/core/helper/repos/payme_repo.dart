import 'package:dio/dio.dart';

import '../../../res/constants.dart';
import '../dio/dio_client.dart';

class PaymentRepo {
  final _dio = DioClient.getDio();
  Future<Response> addCard(int userId, int cardPan, String cardMonth) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
      "card_pan": cardPan,
      "card_month": cardMonth,
    };

    return await _dio.post(
      ApiValues.addCardUrl,
      data: params,
    );
  }

  Future<Response> makePayment(int userId, int cardId, int amount) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
      "card_id": cardId,
      "amount": amount,
    };

    return await _dio.post(
      ApiValues.amountUrl,
      data: params,
    );
  }

  Future<Response> getCards(int userId) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
    };

    return await _dio.post(
      ApiValues.amountUrl,
      data: params,
    );
  }

  Future<Response> getPaymentHistory(int userId) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
    };

    return await _dio.post(
      ApiValues.amountUrl,
      data: params,
    );
  }
}
