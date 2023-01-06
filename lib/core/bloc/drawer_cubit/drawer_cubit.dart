import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import '../../domain/subject_models/subject_model.dart';
import '../../helper/repos/subject_repo.dart';
part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial()) {
    getSubs();
  }
  final _repo = SubjectRepo();
  final _storage = AppStorage();

  Future<void> getSubs() async {
    emit(OnDrawerProgress());
    try {
      final response = await _repo.getSubjects();
      final rowData = response.data as List;
      final rowList = rowData.map((e) => SubjectModel.fromJson(e)).toList();

      ///
      var lastSelectedIndex = await _storage.getDrawerIndex();
      if (lastSelectedIndex == null) {
        emit(DrawerSubjectsLoadedState(0, rowList));
      } else {
        emit(DrawerSubjectsLoadedState(lastSelectedIndex, rowList));
      }

      ///
    } on DioError catch (e) {
      emit(OnDrawerError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(OnDrawerError(e.toString()));
    }
  }

  void chooseSubject(int index) async {
    if (state is DrawerSubjectsLoadedState) {
      await _saveDrawerIndex(index);
      final lastSelectedIndex = await _storage.getDrawerIndex();
      print("Drawer saved is: $lastSelectedIndex");
      final oldState = (state as DrawerSubjectsLoadedState);
      final newState = oldState.copyWith(lastSelectedIndex);
      emit(newState);
    }
  }

  Future<void> _saveDrawerIndex(int index) async {
    await _storage.saveDrawerIndex(index);
    print("Drawer Index is saved");
  }
}
