import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/card_model/card_model.dart';
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
      await _repo.addCard(userId, cardPan, cardMonth);
      emit(OnCardAdded());
    } on DioError catch (e) {
      emit(OnCardError(e.response!.data["message"]));
    } catch (e) {
      emit(OnCardError(e.toString()));
    }
  }

  Future<void> makePayment(int cardId, int amount) async {
    emit(OnCardProgress());
    final userId = await _storage.getUserId();

    try {
      await _repo.makePayment(userId, cardId, amount);
      emit(OnPaymentSent());
    } on DioError catch (e) {
      emit(OnCardError(e.response!.data["message"]));
    } catch (e) {
      emit(OnCardError(e.toString()));
    }
  }

  Future<void> getCards() async {
    emit(OnCardProgress());
    final userId = await _storage.getUserId();

    try {
      await _repo.getCards(userId);
      emit(OnCardAdded());
    } on DioError catch (e) {
      emit(OnCardError(e.response!.data["message"]));
    } catch (e) {
      emit(OnCardError(e.toString()));
    }
  }
}
