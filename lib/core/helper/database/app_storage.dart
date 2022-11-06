import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/res/constants.dart';

class AppStorage {
  Future<void> savePassword(String password) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStorageConstants.passwordKey, password);
  }

  Future<String?> getPassword() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStorageConstants.passwordKey);
  }

  Future<void> saveUserInfo(String data) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStorageConstants.userKey, data);
  }

  Future<String?> getUserInfoInString() async {
    var prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppStorageConstants.userKey);
    return data;
  }

  Future<UserInfo> getUserInfo() async {
    var prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppStorageConstants.userKey);
    return UserInfo.fromJson(jsonDecode(data!));
  }

  Future<void> clearUserInfo() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(AppStorageConstants.userKey);
  }

  Future<void> saveToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStorageConstants.tokenKey, token!);
  }

  Future<String?> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStorageConstants.tokenKey);
  }

  Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(AppStorageConstants.tokenKey);
  }

//all about login status
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> logOut() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
