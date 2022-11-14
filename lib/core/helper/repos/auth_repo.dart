import 'package:dio/dio.dart';
import 'package:test_app/res/constants.dart';

import '../dio/dio_client.dart';

class AuthRepository {
  final _dio = DioClient.getDio();

  Future<Response> getSubjects() async {
    final response = await _dio.get("subjects/index");

    if (response.statusCode == 200) {
      print(response.data);
      return response;
    }
    print(response.data);
    return response.data;
  }

  Future<Response> sighUp(
      String fullName, String phone, String password) async {
    final Map<String, String> params = {
      "phone": phone,
      "fullname": fullName,
      "password": password
    };

    return await _dio.post(
      ApiValues.sighUPUrl,
      data: params,
    );
  }

  Future<Response> logIn(String phone, String password) async {
    final Map<String, String> params = {"phone": phone, "password": password};

    return await _dio.post(
      ApiValues.loginUrl,
      data: params,
    );
  }

  Future<Response> resetPassword(
    String phone,
  ) async {
    final Map<String, String> params = {
      "phone": phone,
    };

    return await _dio.post(
      ApiValues.resetPasswordUrl,
      data: params,
    );
  }

  Future<Response> checkSmsCode(
      int userId, String phone, String smsCode) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
      "phone": phone,
      "sms_live": smsCode,
    };

    return await _dio.post(
      ApiValues.checkSmsUrl,
      data: params,
    );
  }

  Future<Response> checkResetPassWord(
      int userId, String phone, String smsCode) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
      "phone": phone,
      "sms_live": smsCode,
    };

    return await _dio.post(
      ApiValues.resetPasswordUrl,
      data: params,
    );
  }

  Future<Response> logOut(int userId, String authKey) async {
    final Map<String, dynamic> params = {
      "user_id": userId,
      "auth_key": authKey,
    };

    return await _dio.post(
      ApiValues.logoutUrl,
      data: params,
    );
  }

  Future<Response> changePassword(
      String phone, String newPassword, String confirmPassword) async {
    final Map<String, dynamic> params = {
      "phone": phone,
      "new_pass": newPassword,
      "confirm_pass": confirmPassword,
    };

    return await _dio.post(
      ApiValues.changePasswordUrl,
      data: params,
    );
  }
}
