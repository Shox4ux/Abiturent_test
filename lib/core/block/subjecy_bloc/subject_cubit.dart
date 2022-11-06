import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/core/helper/repos/subject_repo.dart';

part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  SubjectCubit() : super(SubjectInitial());

  final _repoS = SubjectRepo();

  List<SubjectModel>? subs;

  Future<void> getSubjects() async {
    emit(OnSubMove());
    try {
      final response = await _repoS.getSubjects();
      print("sub requested");

      final rowData = response.data as List;
      print("rowData : $rowData");

      final subjectList = rowData
          .map(
            (e) => SubjectModel.fromJson(e),
          )
          .toList();
      emit(OnSubReceived(list: subjectList));
      subs = subjectList;
    } on DioError catch (e) {
      emit(OnSubError(error: e.message));
    } on SocketException catch (e) {
      emit(OnSubError(error: e.message));
    } catch (e) {
      emit(OnSubError(error: e.toString()));
    }
  }
}
