import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/domain/patment_model/card_model.dart';
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
      emit(OnCardError(e.response?.data["message"] ?? ""));
    } on SocketException {
      emit(const OnCardError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }

  Future<void> deleteCard(String cardPan, int cardId) async {
    emit(OnCardProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.deleteCard(u.id!, cardPan, cardId);
      emit(OnCardDeleted(response.data["message"]));
    } on DioError catch (e) {
      emit(OnCardError(e.response?.data["message"] ?? ""));
    } on SocketException {
      emit(const OnCardError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnCardError("Tizimda nosozlik"));
    }
  }

  void cardConfirm(bool isConfirmed) async {
    await _storage.savePaymeConfirmed(isConfirmed);
  }

  Future<bool> isConfirmed() async {
    return await _storage.isPaymeConfirmed();
  }

  Future<void> getCards() async {
    emit(OnCardProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.getCards(u.id!);
      final rowData = response.data as List;

      if (rowData.isEmpty) {
        emit(OnCardsEmpty());
        return;
      }
      final rowList = rowData.map((e) => CardModel.fromJson(e)).toList();
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
      emit(OnCardError(e.response?.data["message"] ?? ""));
    } on SocketException {
      emit(const OnCardError("Tarmoqda nosozlik"));
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
