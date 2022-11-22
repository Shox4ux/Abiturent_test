import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/card_model/card_model.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/payme_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  final _repo = PaymentRepo();
  final _storage = AppStorage();

  Future<void> addCard(int cardPan, String cardMonth) async {
    emit(OnCardProgress());
    final userId = await _storage.getUserId();
    try {
      final response = await _repo.addCard(userId, cardPan, cardMonth);
      final rowData = CardModel.fromJson(response.data);
      emit(OnCardAdded(rowData));
    } on DioError catch (e) {
      emit(OnCardError(e.response!.data["message"] ?? ""));
    } catch (e) {
      emit(OnCardError(e.toString()));
    }
  }

  Future<void> makePayment(int cardId, int amount) async {
    emit(OnCardProgress());
    final userId = await _storage.getUserId();

    try {
      await _repo.makePayment(userId, cardId, amount);
      emit(OnMadePayment());
    } on DioError catch (e) {
      emit(OnCardError(e.response!.data["message"] ?? ""));
    } catch (e) {
      emit(OnCardError(e.toString()));
    }
  }

// does not work for a while
  Future<void> getCards() async {
    emit(OnCardProgress());
    final userId = await _storage.getUserId();

    try {
      final response = await _repo.getCards(userId);
      final rowData = response.data as List;
      final rowList = rowData.map((e) => CardModel.fromJson(e)).toList();
      emit(OnCardsReceived(rowList));
    } on DioError catch (e) {
      emit(OnCardError(e.response?.data["message"] ?? ""));
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
