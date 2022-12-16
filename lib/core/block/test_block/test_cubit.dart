import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
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

  final perPage = 10;

  // Future<void> getTestsBySubIdAndType(int subId, int typeIndex) async {
  //   emit(OnTestProgress());
  //   try {
  //     final response = await _repo.getTestsBySubjectId(subId, typeIndex);
  // final allTestData = TestModel.fromJson(response.data);
  //     emit(OnTestSuccess(allTestData));
  //   } catch (e) {
  //     emit(OnTestError(e.toString()));
  //   }
  // }

  Future<void> getTestBySubIdWithPagination(
      int subId, int type, int page) async {
    emit(OnTestProgress());
    try {
      final response =
          await _repo.getTestPaginationByType(subId, type, page, perPage);
      final allTestData = TestModel.fromJson(response.data);
      emit(OnTestSuccess(allTestData));
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
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

  Future<void> sendTestAnswer(
      int questionId, int answerId, int testListId) async {
    emit(OnTestProgress());
    final u = await _storage.getUserInfo();
    try {
      final response =
          await _repo.sendTestAnswer(questionId, answerId, u.id!, testListId);

      if (response.data == 0) {
        emit(OnCelebrate(testListId));
      } else {
        final test = InnerTestModel.fromJson(response.data["next_question"]);
        emit(OnTestInnerSuccess(test));
      }
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
      final rowList = response.data as List;
      final resultList = rowList.map((e) => TestResult.fromJson(e)).toList();
      emit(OnTestCompleted(resultList));

      // emit(OnTestInnerSuccess(test));
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(OnTestError(e.message));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }

  Future<void> getErrorResult(int subId) async {
    emit(OnTestProgress());
    final u = await _storage.getUserInfo();
    try {
      final response = await _repo.getErrorList(u.id!, subId);
      final rowList = response.data as List;
      final errortList = rowList.map((e) => TestResult.fromJson(e)).toList();
      emit(OnReceivedErrorResult(errortList));
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const OnTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }
}
