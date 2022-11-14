import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/block/user_block/user_cubit_cubit.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';

import '../../helper/repos/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final _repo = AuthRepository();
  final _storage = AppStorage();
  final _cubit = UserCubit();

  AuthCubit() : super(AuthInitial());

  int? tempId;
  String? tempPhone;
  UserInfo? _userData;

  Future<UserInfo> getUserData() async {
    return await _storage.getUserInfo();
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
    String fullName,
    String phone,
    String password,
  ) async {
    final realNumber = "998$phone";
    emit(OnProgress());

    try {
      final response = await _repo.sighUp(fullName, realNumber, password);
      emit(OnWaitingSmsResult());

      if (response.statusCode == 200) {
        print(response.data);

        tempId = response.data["user_id"];
        tempPhone = response.data["phone"];

        print("tempId: $tempId");
        print("tempPhone: $tempPhone");

        emit(
          AuthOnSMS(
            id: tempId!,
            phoneNumber: tempPhone!,
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
      emit(const AuthDenied(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
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
      await _storage.saveToken(response.data["user_auth"]);
      await _storage.saveUserInfo(jsonEncode(response.data["user_info"]));

      print("from storage: ${await _storage.getToken()}");
      print("from storage: ${await _storage.getUserInfo()}");

      _userData = await _storage.getUserInfo();
      print(_userData!.fullname);
      emit(UserActive(userInfo: _userData!));

      //this is for appbar
      await _cubit.getUserDataForAppBar(
        _userData!.rating.toString(),
        _userData!.ratingMonth.toString(),
      );
      //
    } on DioError catch (e) {
      emit(AuthDenied(error: e.message));
    } on SocketException catch (e) {
      emit(const AuthDenied(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> checkSmsCode(int userId, String phone, String smsCode) async {
    emit(OnProgress());

    try {
      final response = await _repo.checkSmsCode(userId, phone, smsCode);

      print("sms data: ${response.data}");

      var userData = UserInfo.fromJson(response.data["user"]);
      print(userData.fullname);
      await _storage.saveUserInfo(jsonEncode(response.data["user"]));
      emit(AuthGranted());
    } on SocketException catch (e) {
      emit(const AuthDenied(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> checkResetPassword(
      int userId, String phone, String smsCode) async {
    var realNum = "998$phone";
    emit(OnProgress());

    try {
      final response = await _repo.checkResetPassWord(userId, realNum, smsCode);

      print("sms data: ${response.data}");

      emit(AuthGranted());
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const AuthDenied(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
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
        await _storage.clearToken();
        // await _storage.clearUserInfo();
      }
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const AuthDenied(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> forgotPassword(String phone) async {
    final realPhone = "998$phone";
    emit(OnProgress());
    try {
      final u = await _repo.resetPassword(realPhone);
      var tempId = u.data['id'];
      emit(AuthOnSMS(id: tempId!, phoneNumber: phone));
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const AuthDenied(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> changePassword(
    String phone,
    String newPassword,
    String confirmPassword,
  ) async {
    emit(OnProgress());
    try {
      await _repo.changePassword(
        phone,
        newPassword,
        confirmPassword,
      );
      emit(AuthGranted());
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const AuthDenied(error: "Tarmoqda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  void triggerTimer() {
    emit(OnAuthTime());
  }
}
