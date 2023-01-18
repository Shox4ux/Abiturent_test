import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/res/constants.dart';
import '../../../res/functions/show_toast.dart';
import '../../domain/test_model/test_model.dart';
import '../../helper/database/app_storage.dart';
import '../../helper/repos/test_repo.dart';
part 'dtm_state.dart';

class DtmCubit extends Cubit<DtmState> {
  DtmCubit() : super(DtmInitial());
  final _storage = AppStorage();
  final _repo = TestRepo();
  final _perPage = 10;
  var _currentPage = 1;
  var _testLimit = 0;
  bool _isPaginationEnded = false;
  final _testType = ApiValues.dtmTestType;
  var _currentSubjectId = 0;

  Future<void> getDtmTestBySubIdWithPagination(int subId) async {
    if (_currentSubjectId != subId) {
      _isPaginationEnded = false;
      _currentPage = 1;
    }
    if (_isPaginationEnded) {
      return;
    }
    if (_currentPage == 1) {
      await _getDtmTestsFirstTime(subId);
      _currentPage++;
    }
  }

  Future<void> _getDtmTestsFirstTime(int subId) async {
    _currentSubjectId = subId;
    emit(OnDtmTestProgress());
    final userId = await _storage.getUserId();
    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage, userId!);

      final allTestData = TestModel.fromJson(response.data);
      _testLimit = allTestData.subjects!.testLimit!;

      emit(OnDtmTestReceived(allTestData.subjects!, allTestData.tests!, false));
    } on DioError catch (e) {
      emit(OnDtmTestError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnDtmTestError("Tizimda nosozlik"));
    }
  }

  Future<void> onRefresh(int subId) async {
    _currentPage = 1;
    _isPaginationEnded = false;
    emit(OnDtmTestProgress());
    _currentSubjectId = subId;
    final userId = await _storage.getUserId();

    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage, userId!);

      final allTestData = TestModel.fromJson(response.data);
      _testLimit = allTestData.subjects!.testLimit!;
      emit(OnDtmTestReceived(allTestData.subjects!, allTestData.tests!, false));
      _currentPage++;
    } on DioError catch (e) {
      emit(OnDtmTestError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnDtmTestError("Tizimda nosozlik"));
    }
  }

  Future<void> startDtmPagination(int subId) async {
    if (_isPaginationEnded) {
      showToast("Boshqa testlar mavjud emas");
      return;
    }
    final userId = await _storage.getUserId();

    try {
      final response = await _repo.getTestPaginationByType(
          subId, _testType, _currentPage, _perPage, userId!);
      final allTestData = TestModel.fromJson(response.data);
      _combineDtmNewList(allTestData.tests!);
    } on DioError catch (e) {
      emit(OnDtmTestError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnDtmTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _combineDtmNewList(List<Tests> extraTestList) async {
    _checkIsLastData(extraTestList.length);

    if (state is OnDtmTestReceived) {
      final oldState = (state as OnDtmTestReceived);
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
    }
  }

  void _checkIsLastData(int listLength) {
    if (listLength < _perPage) {
      _isPaginationEnded = true;
      showToast("Boshqa testlar mavjud emas");
      return;
    }
  }
}
