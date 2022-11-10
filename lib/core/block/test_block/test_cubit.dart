import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/block/auth_block/auth_cubit.dart';
import 'package:test_app/core/domain/test_model/test_inner_model.dart';
import 'package:test_app/core/domain/test_model/test_model.dart';
import 'package:test_app/core/domain/test_model/test_result_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());
  final _repo = TestRepo();

  final _storage = AppStorage();

  Future<void> getTestsBySubIdAndType(int subId, int typeIndex) async {
    emit(OnTestProgress());
    try {
      final response = await _repo.getTestsBySubjectId(subId, typeIndex);
      final allTestData = TestModel.fromJson(response.data);

      emit(OnTestSuccess(allTestData));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }

  Future<void> getTestById(int testId) async {
    emit(OnTestProgress());
    final u = await _storage.getUserInfo();

    try {
      final response = await _repo.getTestById(testId, u.id!);

      final test = InnerTestModel.fromJson(response.data);
      emit(OnTestInnerSuccess(test));
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(OnTestError(e.message));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }

  Future<void> sendTestAnswer(int questionId, int answerId) async {
    emit(OnTestProgress());
    final u = await _storage.getUserInfo();

    try {
      final response = await _repo.sendTestAnswer(questionId, answerId, u.id!);
      final test = InnerTestModel.fromJson(response.data["next_question"]);
      emit(OnTestInnerSuccess(test));
    } on DioError catch (e) {
      emit(OnTestError(e.message));
    } on SocketException catch (e) {
      emit(OnTestError(e.message));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }

  Future<void> getResults(int testListId) async {
    emit(OnTestProgress());
    final u = await _storage.getUserInfo();

    try {
      final response = await _repo.getResults(u.id!, testListId);

      final rowTestList = response.data["test_questions"] as List;
      final rowResultList = response.data["test_result"] as List;

      final testList =
          rowTestList.map((e) => InnerTestModel.fromJson(e)).toList();

      final resultList =
          rowResultList.map((e) => TestResult.fromJson(e)).toList();

      // emit(OnTestInnerSuccess(test));
    } on DioError catch (e) {
      emit(OnTestError(e.message));
    } on SocketException catch (e) {
      emit(OnTestError(e.message));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }
}
