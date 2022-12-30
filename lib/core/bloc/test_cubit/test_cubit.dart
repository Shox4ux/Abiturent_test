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

  Future<void> getTestBySubIdWithPagination({
    required int subId,
    required int type,
    required int page,
  }) async {
    emit(OnTestProgress());
    try {
      final response =
          await _repo.getTestPaginationByType(subId, type, page, perPage);
      final allTestData = TestModel.fromJson(response.data);

      if (page > 1) {
        await _combineNewList(allTestData.tests!);
        return;
      } else {
        emit(OnTestSuccess(
          subjectData: allTestData.subjects!,
          testList: allTestData.tests!,
          bookList: allTestData.books!,
        ));
      }
    } on DioError catch (e) {
      emit(OnTestError(e.response!.data["message"]));
    } on SocketException {
      emit(const OnTestError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnTestError("Tizimda nosozlik"));
    }
  }

  Future<void> _combineNewList(List<Tests> extraTestList) async {
    if (state is OnTestSuccess) {
      final oldState = (state as OnTestSuccess);
      final newList = List.of(oldState.testList);
      newList.addAll(extraTestList);
      final newState = oldState.copyWith(newList);
      emit(newState);
    }
  }
}
