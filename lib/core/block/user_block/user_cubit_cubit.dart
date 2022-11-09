import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/helper/repos/user_repo.dart';

import '../../domain/user_model/user_model.dart';

part 'user_cubit_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserCubitInitial());

  final _repo = UserRepo();

  Future<void> callUserRating() async {
    try {
      final response = await _repo.getUserRatings();
      final rowData = response.data as List;

      final subjectList = rowData
          .map(
            (e) => UserInfo.fromJson(e),
          )
          .toList();
      print("rowData : ${subjectList.length}");

      emit(OnSuccess(list: subjectList));
    } on DioError catch (e) {
      emit(OnError(error: e.message));

      print(e);
    } catch (e) {
      emit(OnError(error: e.toString()));

      print(e);
    }
  }

  Future<void> getUserDataForAppBar(String rating, String ratingMonth) async {
    emit(UserForAppBar(rating, ratingMonth));
  }
}
