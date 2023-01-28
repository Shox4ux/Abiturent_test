import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/user_model/rating_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/user_repo.dart';
import '../../../res/functions/show_toast.dart';
import '../../domain/user_model/user_model.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserCubitInitial());
  final _repo = UserRepo();
  final _storage = AppStorage();

  Future<void> getUserDataForAppBar(String rating, String ratingMonth) async {
    emit(UserForAppBar(rating, ratingMonth));
  }

  Future<void> updateProfile(
      String fullName, File? avatar, String tegLink) async {
    emit(OnUserProgress());
    final userId = await _storage.getUserId();
    final token = await _storage.getToken();
    try {
      await _repo.updateProfil(fullName, userId!, avatar, token!, tegLink);
      emit(OnUserUpdated());
    } on DioError catch (e) {
      if (e.response?.statusCode == 413) {
        emit(const OnUserError(error: "Fayl yuklash uchun katta"));
      } else {
        emit(OnUserError(error: e.response!.data["message"]));
      }
    } catch (e) {
      emit(const OnUserError(error: "Tizimda nosozlik"));
    }
  }

  Future<void> deleteUser() async {
    emit(OnUserProgress());
    final int? userId = await _storage.getUserId();
    final String? token = await _storage.getToken();

    if (userId == null || token == null) return;

    try {
      final response = await _repo.deleteUser(userId, token);
      showToast(response.data["message"] ?? "Ma`lumotlar to'liq o`chirildi");
      emit(OnUserDeleted());

      ///
      await _storage.clearToken();
      await _storage.clearUserId();

      ///
    } on DioError catch (e) {
      if (e.response?.statusCode == 413) {
        emit(const OnUserError(error: "Fayl yuklash uchun katta"));
      }
    } catch (e) {
      emit(const OnUserError(error: "Tizimda nosozlik"));
    }
  }
}
