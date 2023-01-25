import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/domain/user_model/user_model.dart';
import 'package:test_app/res/constants.dart';

class AppStorage {
  Future<void> saveUserId(int userId) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppStorageConstants.userIdKey, userId);
  }

  Future<int?> getUserId() async {
    var prefs = await SharedPreferences.getInstance();
    final data = prefs.getInt(AppStorageConstants.userIdKey);
    return data;
  }

  Future<void> saveUserInfo(String data) async {
    // await clearUserInfo();
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
    if (token == null) {
      print("Token is null");
      return;
    }
    await prefs.setString(AppStorageConstants.tokenKey, token);
  }

  Future<String?> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStorageConstants.tokenKey);
  }

  Future<void> clearToken() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(AppStorageConstants.tokenKey);
  }

  Future<void> savePaymeConfirmed(bool isConfirmed) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStorageConstants.paymeKey, isConfirmed);
  }

  Future<bool> isPaymeConfirmed() async {
    var prefs = await SharedPreferences.getInstance();

    final val = prefs.getBool(AppStorageConstants.paymeKey);

    if (val == null) {
      return false;
    }
    return val;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> logOut() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveDrawerIndex(int index) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppStorageConstants.drawerIndexKey, index);
  }

  Future<int?> getDrawerIndex() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppStorageConstants.drawerIndexKey);
  }
}
