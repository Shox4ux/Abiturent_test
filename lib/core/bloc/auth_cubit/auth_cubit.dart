import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import '../../../res/functions/show_toast.dart';
import '../../helper/repos/auth_repo.dart';
import '../../helper/repos/user_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final _repo = AuthRepository();
  final _storage = AppStorage();
  final _urepo = UserRepo();
  AuthCubit() : super(AuthInitial()) {
    getUserData();
  }
//  userInActive = 8;
  final userBlocked = 9;

  Future<void> getUserData() async {
    emit(OnAuthProgress());
    try {
      final userOldData = await _storage.getUserInfo();

      if (userOldData == null) {
        return;
      }
      final rowData = await _urepo.getUserProfile(userOldData.id!);
      final userData = UserInfo.fromJson(rowData.data);

      if (userData.status == userBlocked) {}

      emit(UserActive(userInfo: userData));
    } on DioError catch (e) {
      emit(
          AuthDenied(error: e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik "));
      print(e);
    }
  }

  Future<void> isLogged() async {
    final t = await _storage.getUserInfo();
    if (t.fullname != null) {
      emit(UserActive(userInfo: t));
    } else {
      emit(const AuthDenied(error: "No data"));
    }
  }

  Future<void> authSignUp(
      String fullName, String phone, String password) async {
    final realNumber = "998$phone";
    emit(OnAuthProgress());

    try {
      final response = await _repo.sighUp(fullName, realNumber, password);
      emit(OnWaitingSmsResult());
      print(response.data);
      final tempId = response.data["user_id"];
      final tempPhone = response.data["phone"];

      print("tempId: $tempId");
      print("tempPhone: $tempPhone");
      emit(
        AuthOnSMS(id: tempId!, phoneNumber: phone),
      );
    } on DioError catch (e) {
      emit(
          AuthDenied(error: e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> authLogin(String phone, String password) async {
    final realNumber = "998$phone";
    emit(OnAuthProgress());
    print("login");

    try {
      final response = await _repo.logIn(realNumber, password);
      print("login end");
      print(response.data["user_info"]);
      await _storage.saveToken(response.data["user_auth"]);
      await _storage.saveUserInfo(jsonEncode(response.data["user_info"]));

      print("from storage: ${await _storage.getToken()}");
      print("from storage: ${await _storage.getUserInfo()}");

      var userData = await _storage.getUserInfo();
      print(userData.fullname);
      emit(UserActive(userInfo: userData));
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        emit(OnAuthBlocked(message: e.message));
      }
      emit(
          AuthDenied(error: e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> checkSmsCode(int userId, String phone, String smsCode) async {
    emit(OnAuthProgress());
    try {
      final response = await _repo.checkSmsCode(userId, phone, smsCode);
      print("sms data: ${response.data}");
      var userData = UserInfo.fromJson(response.data["user"]);
      print(userData.fullname);
      await _storage.saveUserInfo(jsonEncode(response.data["user"]));
      emit(AuthGranted());
    } on DioError catch (e) {
      emit(
          AuthDenied(error: e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> checkResetPassword(
      int userId, String realPhone, String smsCode) async {
    emit(OnAuthProgress());
    try {
      final response =
          await _repo.checkResetPassWord(userId, realPhone, smsCode);
      print("sms data: ${response.data}");
      emit(AuthGranted());
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response?.data["message"] ?? ""));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> authLogOut() async {
    emit(OnAuthProgress());
    var user = await _storage.getUserInfo();
    var authKey = await _storage.getToken();
    print("logout: ${user.fullname}");
    try {
      var response = await _repo.logOut(user.id!, authKey!);
      if (response.statusCode == 200) {
        emit(LogedOut());
        await _storage.clearToken();
      }
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response?.data["message"] ?? ""));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> forgotPassword(String phone) async {
    final realPhone = "998$phone";
    emit(OnAuthProgress());
    try {
      final response = await _repo.resetPassword(realPhone);
      final rowData = response.data["id"];
      showToast(response.data["message"]);
      emit(AuthOnSMS(id: rowData, phoneNumber: phone));
    } on DioError catch (e) {
      emit(AuthDenied(
          error: e.response?.data["message"] ??
              "Tizimda nosozlik, qaytattan urinib ko'ring"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> changePassword(
      String phone, String newPassword, String confirmPassword) async {
    emit(OnAuthProgress());
    try {
      await _repo.changePassword(
        phone,
        newPassword,
        confirmPassword,
      );
      emit(AuthGranted());
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response?.data["message"] ?? ""));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }
}
