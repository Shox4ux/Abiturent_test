import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/res/constants.dart';
import '../../../res/functions/show_toast.dart';
import '../../domain/test_model/test_model.dart';
import '../../helper/repos/test_repo.dart';
part 'dtm_state.dart';

class DtmCubit extends Cubit<DtmState> {
  DtmCubit() : super(DtmInitial());
  final _repo = TestRepo();
  final _perPage = 10;
  var _currentPage = 1;
  bool _isPaginationEnded = false;
  final _testType = ApiValues.dtmTestType;
  var _currentSubjectId = 0;

  Future<void> getDtmTestBySubIdWithPagination(int subId) async {
    if (_currentSubjectId != subId) {
      _isPaginationEnded = false;
      _currentPage = 1;
    }
    if (_isPaginationEnded) {
      showToast("Testlar tugadi");
      return;
    }
    if (_currentPage == 1) {
      await _getDtmTestsFirstTime(subId);
      _currentPage++;
    } else {
      await _startDtmPagination(subId);
      _currentPage++;
    }
  }

  Future<void> _getDtmTestsFirstTime(int subId) async {
    _currentSubjectId = subId;
    emit(OnDtmTestProgress());
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage);
      final allTestData = TestModel.fromJson(response.data);

      if (allTestData.tests!.length < _perPage) {
        _isPaginationEnded = true;
      }

      emit(OnDtmTestReceived(allTestData.subjects!, allTestData.tests!));
    } on DioError catch (e) {
      emit(OnDtmTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnDtmTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnDtmTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _startDtmPagination(int subId) async {
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage);
      final allTestData = TestModel.fromJson(response.data);
      _combineDtmNewList(allTestData.tests!);
    } on DioError catch (e) {
      emit(OnDtmTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnDtmTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnDtmTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _combineDtmNewList(List<Tests> extraTestList) async {
    _checkIsLastData(extraTestList.length);

    if (state is OnDtmTestReceived) {
      print("state is $state");
      final oldState = (state as OnDtmTestReceived);
      final newList = List.of(oldState.testList);
      newList.addAll(extraTestList);
      final newState = oldState.copyWith(newList);
      emit(newState);
    }
  }

  void _checkIsLastData(int listLength) {
    if (listLength < _perPage) {
      _isPaginationEnded = true;
      showToast("Testlar tugadi");
    }
  }
}
