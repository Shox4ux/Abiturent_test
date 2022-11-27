import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/domain/patment_model/payment_response.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/payme_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  final _repo = PaymentRepo();
  final _storage = AppStorage();

  Future<void> makePayment(
      String cardPeriod, String cardPan, String amount) async {
    emit(OnCardProgress());
    final userId = await _storage.getUserId();
    try {
      final response =
          await _repo.makePayment(userId, cardPan, amount, cardPeriod);
      final rowData = PaymentResponse.fromJson(response.data);
      emit(OnMadePayment(rowData));
    } on DioError catch (e) {
      emit(OnCardError(e.response!.data["message"] ?? ""));
    } catch (e) {
      emit(OnCardError(e.toString()));
    }
  }

  Future<void> getPaymentHistory() async {
    emit(OnPayHistoryProgress());
    final userId = await _storage.getUserId();
    try {
      final response = await _repo.getPaymentHistory(userId);
      final rowData = response.data as List;
      final rowList = rowData.map((e) => PaymentHistory.fromJson(e)).toList();
      emit(OnPayHistoryReceived(rowList));
    } on DioError catch (e) {
      emit(OnCardError(e.response?.data["message"] ?? ""));
    } catch (e) {
      emit(OnCardError(e.toString()));
    }
  }
}
