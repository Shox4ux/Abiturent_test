import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/mistakes_model/mistakes_model.dart';

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
      if (response.data["data"].isEmpty) {
        emit(OnMistakesEmpty(response.data["subject_name"]));
        return;
      }
      final model = MistakesModel.fromJson(response.data);
      emit(OnMistakesReceived(model));
    } on DioError catch (e) {
      emit(OnMistakesError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } on SocketException {
      emit(const OnMistakesError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnMistakesError("Tizimda nosozlik"));
    }
  }
}
