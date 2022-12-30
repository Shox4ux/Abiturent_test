import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../domain/test_model/test_result_model.dart';
import '../../helper/database/app_storage.dart';
import '../../helper/repos/test_repo.dart';

part 'mistakes_state.dart';

class MistakesCubit extends Cubit<MistakesState> {
  MistakesCubit() : super(MistakesInitial());

  final _repo = TestRepo();
  final _storage = AppStorage();

  Future<void> getErrorList(int subjectId) async {
    emit(OnMistakesProgress());
    final userId = await _storage.getUserId();
    try {
      final response = await _repo.getErrorList(userId, subjectId);
      final rowData = response.data as List;
      if (rowData.isEmpty) {
        emit(OnMistakesEmpty());
        return;
      }
      final rowList = rowData.map((e) => TestResult.fromJson(e)).toList();
      emit(OnMistakesReceived(rowList));
    } on DioError catch (e) {
      emit(OnMistakesError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } on SocketException {
      emit(const OnMistakesError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnMistakesError("Tizimda nosozlik"));
    }
  }
}
