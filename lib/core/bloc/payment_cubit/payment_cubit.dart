import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/domain/patment_model/card_list_model.dart';
import 'package:test_app/core/domain/patment_model/card_model.dart';
import 'package:test_app/core/domain/patment_model/on_payment_done.dart';
import 'package:test_app/core/domain/patment_model/payment_response.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/payme_repo.dart';
import 'package:test_app/res/functions/show_toast.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  final _repo = PaymentRepo();
  final _storage = AppStorage();

  Future<void> makePayment(int cardId, String amount) async {
    emit(OnCardProgress());
    final userId = await _storage.getUserId();
    final realAmount = amount.replaceAll(",", "");
    try {
      final response = await _repo.makePayment(userId, cardId, realAmount);
      final rowData = OnPaymentDone.fromJson(response.data);
      emit(OnMadePayment(rowData));
    } on DioError catch (e) {
      // emit(OnCardError(e.response?.data["message"] ?? ""));
      getCards();
      showToast(e.response?.data["message"]);
    } on SocketException {
      emit(const OnCardError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }

  Future<void> deleteCard(int cardId) async {
    emit(OnCardProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.deleteCard(u.id!, cardId);
      showToast(response.data["message"]);
      await getCards();
    } on DioError catch (e) {
      // emit(OnCardError(e.response?.data["message"] ?? ""));
      showToast(e.response?.data["message"] ?? "");
      await getCards();
    } on SocketException {
      emit(const OnCardError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }

  Future<void> getCards() async {
    emit(OnCardProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.getCards(u.id!);

      if (response.data.isEmpty) {
        emit(OnCardsEmpty());
        return;
      }
      final rowData = response.data as List;
      final rowList = rowData.map((e) => CardListModel.fromJson(e)).toList();
      emit(OnCardsReceived(rowList));
    } on DioError catch (e) {
      emit(OnCardError(e.response?.data["message"] ?? ""));
    } on SocketException {
      emit(const OnCardError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }

  Future<void> addCard(String cardPan, String cardMonth) async {
    emit(OnCardProgress());
    final u = await _storage.getUserInfo();
    try {
      final resonse =
          await _repo.addCard(u.id!, cardPan, cardMonth, u.fullname!);
      final rowData = CardModel.fromJson(resonse.data);
      emit(OnCardAdded(rowData));
    } on DioError catch (e) {
      showToast(e.response?.data["message"] ?? "");
      // emit(OnCardError(e.response?.data["message"] ?? ""));
    } catch (e) {
      print(e);
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }

  Future<void> refreshCardSms(int cardId) async {
    emit(OnCardProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.refreshCardSms(u.id!, cardId);
    } on DioError catch (e) {
      emit(OnCardError(e.response?.data["message"] ?? ""));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }

  Future<void> verifyCardSmsCode(int cardId, String smsCode) async {
    emit(OnCardProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.verifyCardSmsCode(u.id!, cardId, smsCode);
      showToast(response.data["message"]);
      emit(OnCardConfirmed());
      await getCards();
    } on DioError catch (e) {
      emit(OnCardError(e.response?.data["message"] ?? ""));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
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
    } on SocketException {
      emit(const OnCardError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }
}
