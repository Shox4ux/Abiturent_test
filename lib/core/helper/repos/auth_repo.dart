import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class AuthRepository {
  final _dio = DioClient.getDio();

  Future<Response> sighUp(
      String fullName, String phone, String password) async {
    var formData = FormData.fromMap(
        {"phone": phone, "fullname": fullName, "password": password});

    return await _dio.post(
      ApiValues.sighUPUrl,
      data: formData,
    );
  }

  Future<Response> logIn(String phone, String password) async {
    var formData = FormData.fromMap({"phone": phone, "password": password});
    return await _dio.post(ApiValues.loginUrl, data: formData);
  }

  Future<Response> forgotPassword(String phone) async {
    var formData = FormData.fromMap({"phone": phone});
    return await _dio.post(ApiValues.resetPasswordUrl, data: formData);
  }

  Future<Response> checkRegisterSmsCode(
      int userId, String phone, String smsCode) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "phone": phone,
      "sms_live": smsCode,
    });
    return await _dio.post(ApiValues.checkSmsUrl, data: formData);
  }

  Future<Response> checkForgotPasswordSmsCode(
      int userId, String phone, String smsCode) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "phone": phone,
      "sms_live": smsCode,
    });
    return await _dio.post(ApiValues.resetPasswordUrl, data: formData);
  }

  Future<Response> logOut(int userId, String authKey) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "auth_key": authKey,
    });
    return await _dio.post(ApiValues.logoutUrl, data: formData);
  }

  Future<Response> refreshSmsCode(int userId, String phone) async {
    var formData = FormData.fromMap({
      "user_id": userId,
      "phone": phone,
    });
    return await _dio.post(ApiValues.refreshSmsCode, data: formData);
  }

  Future<Response> changePassword(
    int userId,
    String authKey,
    String phone,
    String newPassword,
    String confirmPassword,
  ) async {
    var formData = FormData.fromMap({
      "user_id": phone,
      "auth_token": phone,
      "phone": phone,
      "new_pass": newPassword,
      "confirm_pass": confirmPassword,
    });

    return await _dio.post(
      ApiValues.changePasswordUrl,
      data: formData,
    );
  }
}
