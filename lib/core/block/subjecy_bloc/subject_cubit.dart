import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/core/helper/repos/subject_repo.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  SubjectCubit() : super(SubjectInitial());

  final _repo = SubjectRepo();

  int getSubId(int subId) {
    print("from test cubit id:$subId");
    return subId;
  }

  Future<void> getSubList() async {
    emit(OnSubMove());
    try {
      final response = await _repo.getSubjects();
      final rowList = response.data as List;
      final subList = rowList.map((e) => SubjectModel.fromJson(e)).toList();

      emit(OnSubReceived(list: subList));
    } on DioError catch (e) {
      emit(OnSubError(error: e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const OnSubError(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnSubError(error: "Tarmoqda nosozlik"));
    }
  }
}
