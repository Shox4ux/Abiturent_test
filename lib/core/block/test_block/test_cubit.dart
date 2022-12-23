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

  Future<void> getTestBySubIdWithPagination(
      int subId, int type, int page) async {
    emit(OnTestProgress());
    try {
      final response =
          await _repo.getTestPaginationByType(subId, type, page, perPage);
      final allTestData = TestModel.fromJson(response.data);

      if (page > 1) {
        await _goFurther(allTestData.tests!);
      }

      emit(
        OnTestSuccess(
          subjectData: allTestData.subjects!,
          testList: allTestData.tests!,
          bookList: allTestData.books!,
        ),
      );
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _goFurther(List<Tests> extraTestList) async {
    final oldState = (state as OnTestSuccess);
    final newState = oldState.copyWith(extraTestList);
    emit(newState);
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

      if (rowList.isEmpty) {
        print("no errors");
      }
      final errortList = rowList.map((e) => TestResult.fromJson(e)).toList();
      emit(OnReceivedErrorResult(errortList));
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(OnTestError(e.toString()));
    }
  }
}
