import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/p_h_model/payment_history_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/payme_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  final _repo = PaymentRepo();
  final _storage = AppStorage();

  Future<void> getPaymentHistory(int userId) async {
    emit(OnHistoryProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.getPaymentHistory(u.id!);

      final rowData = response.data as List;

      final rowList = rowData.map((e) => PaymentHistory.fromJson(e)).toList();
      emit(OnHistorySuccess(rowList));
    } on DioError catch (e) {
      emit(OnHistoryError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(OnHistoryError(e.message));
    } catch (e) {
      emit(OnHistoryError(e.toString()));
    }
  }

  Future<void> getTestById(int testId) async {}
}
