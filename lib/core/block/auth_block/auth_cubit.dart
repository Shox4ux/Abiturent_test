import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';

import '../../domain/error_model/error_model.dart';
import '../../domain/subject_models/subject_model.dart';
import '../../helper/repos/auth_repo.dart';
import '../../helper/repos/subject_repo.dart';
import '../subjecy_bloc/subject_cubit.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final _repo = AuthRepository();
  final _storage = AppStorage();

  AuthCubit() : super(AuthInitial());

  var tempId = "";
  var tempPhone = "";
  UserInfo? userData;

  void checkFields(String fullName, String phone, String password) {
    if (password.length < 6) {
      emit(
        const AuthDenied(error: "Password should consist 6 or more symbols"),
      );
    }
    if (phone.length < 7) {
      emit(
        const AuthDenied(error: "Phone number should be 7"),
      );
    } else {
      authSignUp(fullName, phone, password);
    }
  }

  Future<UserInfo> getUserData() async {
    return await _storage.getUserInfo();
  }

  Future<void> authSignUp(
    String fullName,
    String phone,
    String password,
  ) async {
    final realNumber = "998$phone";

    try {
      final response = await _repo.sighUp(fullName, realNumber, password);
      emit(OnWaitingSmsResult());

      if (response.statusCode == 200) {
        print(response.data);

        tempId = response.data["user_id"].toString();
        tempPhone = response.data["phone"];

        print("tempId: $tempId");
        print("tempPhone: $tempPhone");

        emit(
          AuthOnSMS(
            id: tempId,
            phoneNumber: tempPhone,
          ),
        );
      }
    } on DioError catch (e) {
      print(e.response);
      emit(
        AuthDenied(
          error: e.response!.data.toString(),
        ),
      );
    } on SocketException catch (e) {
      emit(
        AuthDenied(
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(
        AuthDenied(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> authLogin(String phone, String password) async {
    final realNumber = "998$phone";
    emit(OnProgress());
    print("login");

    try {
      final response = await _repo.logIn(realNumber, password);
      print("login end");
      print(response.data["user_info"]);
      // await _storage.saveToken(response.data["user_auth"]);
      // await _storage.saveUserInfo(jsonEncode(response.data["user_info"]));
      // final user = await _storage.getUserInfo();

      userData = UserInfo.fromJson(response.data["user_info"]);
      emit(UserActive(userInfo: UserInfo.fromJson(response.data["user_info"])));
      // print(user.fullname);
    } on DioError catch (e) {
      AuthDenied(error: e.message);
    } on SocketException catch (e) {
      AuthDenied(error: e.message);
    } catch (e) {
      AuthDenied(error: e.toString());
    }
  }

  Future<void> checkSmsCode(String userId, String phone, String smsCode) async {
    try {
      final response = await _repo.checkSmsCode(userId, phone, smsCode);

      if (response.statusCode == 200) {
        print("sms data: ${response.data}");

        var userData = UserInfo.fromJson(response.data["user"]);
        print(userData.fullname);
        await _storage.saveUserInfo(jsonEncode(response.data["user"]));
        emit(AuthGranted());
      }
      if (response.statusCode == 422) {
        emit(AuthDenied(error: response.data));
      }
    } on DioError catch (e) {
      emit(AuthDenied(error: e.error));
      print(e.response);
    } catch (e) {
      emit(AuthDenied(error: e.toString()));
    }
  }

  Future<void> authLogOut() async {
    var user = await _storage.getUserInfo();
    var authKey = await _storage.getToken();

    print("logout: ${user.fullname}");
    try {
      var response = await _repo.logOut(user.id!, authKey!);
      if (response.statusCode == 200) {
        emit(LogedOut());
      }
    } on DioError catch (e) {
      emit(AuthDenied(error: e.toString()));
    } on SocketException catch (e) {
      emit(AuthDenied(error: e.toString()));
    } catch (e) {
      emit(AuthDenied(error: e.toString()));
    }
  }

  Future<void> forgotPassword(String phone) async {
    final realPhone = "998$phone";

    try {
      final response = await _repo.resetPassword(realPhone);
      print(response.data);
      if (response.statusCode == 200) {
        emit(AuthGranted());
      }
    } on DioError catch (e) {
      emit(AuthDenied(error: e.message));
    } on SocketException catch (e) {
      emit(AuthDenied(error: e.message));
    } catch (e) {
      emit(AuthDenied(error: e.toString()));
    }
  }

  Future<void> changePassword(
      String newPassword, String confirmPassword) async {
    var user = await _storage.getUserInfo();
    var token = await _storage.getToken();
    var oldPassword = await _storage.getPassword();
    try {
      final response = await _repo.changePassword(
          user.id!, token!, oldPassword!, newPassword, confirmPassword);
    } on DioError catch (e) {
      emit(AuthDenied(error: e.error));
    }
  }
}
