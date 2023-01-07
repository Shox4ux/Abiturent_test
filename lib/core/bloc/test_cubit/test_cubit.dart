import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/test_model/test_inner_model.dart';
import 'package:test_app/core/domain/test_model/test_model.dart';
import 'package:test_app/core/domain/test_model/test_result_model.dart';
import 'package:test_app/core/helper/repos/test_repo.dart';
import 'package:test_app/res/constants.dart';
import 'package:test_app/res/functions/show_toast.dart';
part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());
  final _repo = TestRepo();
  final _perPage = 10;
  var _testLimit = 0;
  var _currentPage = 1;
  bool _isPaginationEnded = false;
  final _testType = ApiValues.ordinaryTestType;
  int _currentSubjectId = 0;

  Future<void> getTestBySubIdWithPagination(int subId) async {
    if (_currentSubjectId != subId) {
      _currentPage = 1;
      _isPaginationEnded = false;
    }

    if (_isPaginationEnded) {
      showToast("Testlarni bori shu");
      return;
    }
    if (_currentPage == 1) {
      await _getTestsFirstTime(subId);
    }
  }

  Future<void> onRefresh(int subId) async {
    _currentPage = 1;
    emit(OnTestProgress());
    _currentSubjectId = subId;
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage);

      final allTestData = TestModel.fromJson(response.data);
      _testLimit = allTestData.subjects!.testLimit!;
      emit(
        OnTestSuccess(
          false,
          subjectData: allTestData.subjects!,
          testList: allTestData.tests!,
        ),
      );
      _currentPage++;
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _getTestsFirstTime(int subId) async {
    emit(OnTestProgress());
    _currentSubjectId = subId;
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage);

      final allTestData = TestModel.fromJson(response.data);
      _testLimit = allTestData.subjects!.testLimit!;
      emit(
        OnTestSuccess(
          false,
          subjectData: allTestData.subjects!,
          testList: allTestData.tests!,
        ),
      );
      _currentPage++;
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
    }
  }

  Future<void> startTestPagination(int subId) async {
    if (_isPaginationEnded) {
      showToast("Boshqa testlar mavjud emas");
      return;
    }
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage);
      final allTestData = TestModel.fromJson(response.data);
      await _combineTestNewList(allTestData.tests!);
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _combineTestNewList(List<Tests> extraTestList) async {
    if (state is OnTestSuccess) {
      final oldState = (state as OnTestSuccess);

      if (oldState.testList.length == _testLimit) {
        _isPaginationEnded = true;
        showToast("Boshqa testlar mavjud emas");
        final newState = oldState.changeBool(true);
        emit(newState);
        return;
      }

      final newList = List.of(oldState.testList);
      newList.addAll(extraTestList);
      final newState = oldState.copyWith(newList);
      emit(newState);
      _currentPage++;
    }
  }
}
