import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../domain/subject_models/subject_model.dart';
import '../../helper/repos/subject_repo.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());
  final _repo = SubjectRepo();

  int? testType;

  int? drawerItemIndex;

  void saveSubId(int id) {
    emit(DrawerSubId(id));
    print("from cubit $id");
  }

  void savePressedIndex(int index) {
    drawerItemIndex = index;
    print("from drawer cubit $drawerItemIndex");
  }

  int getPressedIndex() {
    if (drawerItemIndex == null) {
      return 0;
    } else {
      return drawerItemIndex!;
    }
  }

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
