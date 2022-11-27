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
      final subjectList = rowData.map((e) => UserInfo.fromJson(e)).toList();
      emit(OnSuccess(list: subjectList));
    } on DioError catch (e) {
      emit(OnError(error: e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const OnError(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError(error: "Tizimda nosozlik"));
    }
  }

  Future<void> getUserDataForAppBar(String rating, String ratingMonth) async {
    emit(UserForAppBar(rating, ratingMonth));
  }

  Future<void> updateProfile(String fullName, String avatar) async {
    emit(OnUserProgress());
    final u = await _storage.getUserInfo();
    final t = await _storage.getToken();
    try {
      final response = await _repo.updateProfil(fullName, u.id!, avatar, t!);
      print(response.data);
    } on DioError catch (e) {
      emit(OnError(error: e.response!.data["message"]));
    } on SocketException {
      emit(const OnError(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError(error: "Tizimda nosozlik"));
    }
  }
}
