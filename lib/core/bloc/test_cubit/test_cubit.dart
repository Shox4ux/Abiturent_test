import 'dart:io';
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
      showToast("Testlar tugadi");
      return;
    }
    if (_currentPage == 1) {
      await _getTestsFirstTime(subId);
    } else {
      await _startTestPagination(subId);
    }
  }

  Future<void> _getTestsFirstTime(int subId) async {
    emit(OnTestProgress());
    _currentSubjectId = subId;
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage);
      final allTestData = TestModel.fromJson(response.data);
      emit(OnTestSuccess(
        subjectData: allTestData.subjects!,
        testList: allTestData.tests!,
      ));
      _currentPage++;
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _startTestPagination(int subId) async {
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _currentPage, _currentPage, _perPage);
      final allTestData = TestModel.fromJson(response.data);
      _combineTestNewList(allTestData.tests!);
      _currentPage++;
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _combineTestNewList(List<Tests> extraTestList) async {
    if (extraTestList.length < _perPage) {
      _isPaginationEnded = true;
    }
    if (state is OnTestSuccess) {
      final oldState = (state as OnTestSuccess);
      final newList = List.of(oldState.testList);
      newList.addAll(extraTestList);
      final newState = oldState.copyWith(newList);
      emit(newState);
    }
  }
}
