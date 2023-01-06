import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';

import '../../domain/test_model/test_inner_model.dart';
import '../../domain/test_model/test_result_model.dart';

part 'inside_test_state.dart';

class InnerTestCubit extends Cubit<InsideTestState> {
  InnerTestCubit() : super(InsideTestInitial());
  final _repo = TestRepo();
  final _storage = AppStorage();

  Future<void> getTestById(int testId) async {
    emit(OnInnerTestProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.getTestById(testId, u.id!);
      final test = InnerTestModel.fromJson(response.data);
      emit(OnTestInnerSuccess(test));
    } on DioError catch (e) {
      emit(OnInnerTestError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(OnInnerTestError(e.message));
    } catch (e) {
      emit(OnInnerTestError(e.toString()));
    }
  }

  Future<void> sendTestAnswer(
      int questionId, int answerId, int testListId) async {
    emit(OnInnerTestProgress());
    final u = await _storage.getUserInfo();
    try {
      final response =
          await _repo.sendTestAnswer(questionId, answerId, u.id!, testListId);

      if (response.data == 0) {
        emit(OnInnerTestCelebrate(testListId));
      } else {
        final test = InnerTestModel.fromJson(response.data["next_question"]);
        emit(OnTestInnerSuccess(test));
      }
    } on DioError catch (e) {
      emit(OnInnerTestError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } on SocketException {
      emit(const OnInnerTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnInnerTestError("Tizimda nosozlik"));
    }
  }

  Future<void> getResults(int testListId) async {
    emit(OnInnerTestProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.getResults(u.id!, testListId);
      final rowList = response.data as List;
      final resultList = rowList.map((e) => TestResult.fromJson(e)).toList();
      emit(OnInnerTestCompleted(resultList));
    } on DioError catch (e) {
      emit(OnInnerTestError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const OnInnerTestError("Tizimda nosozlik"));
    }
  }
}
