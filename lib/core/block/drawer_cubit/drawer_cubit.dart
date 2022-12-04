import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/helper/database/app_storage.dart';

import '../../domain/subject_models/subject_model.dart';
import '../../helper/repos/subject_repo.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());
  final _repo = SubjectRepo();

  int? testType;

  void saveSubId(int id) {
    emit(DrawerSubId(id));
  }

  int? selectedIndex;

  Future<void> getSubs() async {
    emit(OnDrawerProgress());
    try {
      final response = await _repo.getSubjects();
      final rowData = response.data as List;
      final rowList = rowData.map((e) => SubjectModel.fromJson(e)).toList();
      emit(OnDrawerSubsReceived(rowList));
    } on SocketException catch (e) {
      emit(const OnDrawerError("Tarmoqda nosozlik"));
    } on DioError catch (e) {
      emit(OnDrawerError(e.response!.data["message"]));
    } catch (e) {
      emit(OnDrawerError(e.toString()));
    }
  }
}
