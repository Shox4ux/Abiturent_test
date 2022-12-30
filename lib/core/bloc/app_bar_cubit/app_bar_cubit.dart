import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../domain/user_model/common_rating.dart';
import '../../helper/database/app_storage.dart';
import '../../helper/repos/user_repo.dart';
part 'app_bar_state.dart';

class AppBarCubit extends Cubit<AppBarState> {
  AppBarCubit() : super(AppBarInitial());
  final _repo = UserRepo();
  final _storage = AppStorage();

  Future<void> getRatingBySubject(int subjectId) async {
    emit(OnAppBarRatingProgress());
    final userData = await _storage.getUserInfo();
    try {
      final response =
          await _repo.getUserRatingBySubject(subjectId, userData.id!);
      final rowData = CommonRatingModel.fromJson(response.data);
      emit(OnAppBarRatingReceived(rowData));
    } on DioError catch (e) {
      emit(OnAppBarRatingError(
          error: e.response!.data["message"] ?? "Tizimda nosozlik"));
    } on SocketException {
      emit(const OnAppBarRatingError(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnAppBarRatingError(error: "Tarmoqda nosozlik"));
    }
  }
}
