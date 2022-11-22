import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/block/drawer_cubit/drawer_cubit.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/user_repo.dart';

import '../../domain/user_model/user_model.dart';

part 'user_cubit_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserCubitInitial());

  final _repo = UserRepo();
  final _storage = AppStorage();
  Future<void> callUserRating(int subId) async {
    try {
      final response = await _repo.getUsersRatings(subId);
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

  Future<void> updateProfile() async {
    emit(OnUserProgress());
    final u = await _storage.getUserInfo();

    try {
      final rowData = await _repo.getUserProfile(u.id!);

      emit(OnProflieUpdated(UserInfo.fromJson(rowData.data)));

      await _storage.saveUserInfo(jsonEncode(UserInfo.fromJson(rowData.data)));
      final newData = await _storage.getUserInfo();
      print("from update ${newData.fullname}");
    } on SocketException catch (e) {
      emit(OnError(error: e.message));
    } catch (e) {
      emit(const OnError(error: "Tizimda nosozlik"));
    }
  }
}
