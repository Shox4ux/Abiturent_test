import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/res/constants.dart';

class AppStorage {
  final storage = const FlutterSecureStorage();

  Future<void> saveUserId(int userId) async {
    await storage.write(
        key: AppStorageConstants.userIdKey, value: userId.toString());
  }

  Future<int?> getUserId() async {
    final data = await storage.read(key: AppStorageConstants.userIdKey);
    if (data == null) {
      return null;
    } else {
      return int.parse(data);
    }
  }

  Future<void> clearUserId() async {
    await storage.delete(key: AppStorageConstants.userIdKey);
  }

  ///

  Future<void> saveToken(String? token) async {
    await storage.write(key: AppStorageConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    String? value = await storage.read(key: AppStorageConstants.tokenKey);
    return value;
  }

  Future<void> clearToken() async {
    await storage.delete(key: AppStorageConstants.tokenKey);
  }

  ////

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: AppStorageConstants.tokenKey);
    return token != null;
  }

  /////

  Future<void> saveDrawerIndex(int index) async {
    await storage.write(
        key: AppStorageConstants.drawerIndexKey, value: index.toString());
  }

  Future<int?> getDrawerIndex() async {
    final data = await storage.read(key: AppStorageConstants.drawerIndexKey);
    if (data == null) {
      return null;
    } else {
      return int.parse(data);
    }
  }

  ///////////
  ///
  Future<void> saveLastSelectedSubjectId(int subjectID) async {
    await storage.write(
        key: AppStorageConstants.subjectIdKey, value: subjectID.toString());
  }

  Future<int?> getLastSelectedSubjectId() async {
    final data = await storage.read(key: AppStorageConstants.subjectIdKey);
    if (data == null) {
      return null;
    } else {
      return int.parse(data);
    }
  }

  ////
  Future<void> saveNewsCreatedDate(String createdDate) async {}
}
