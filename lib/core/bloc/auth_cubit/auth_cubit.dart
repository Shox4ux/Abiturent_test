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
    // getUserData();
  }
  final userBlocked = 9;

  Future<void> getUserData() async {
    emit(OnUserDataProgress());
    try {
      final userId = await _storage.getUserId();

      if (userId == null) {
        return;
      }
      final rowData = await _urepo.getUserProfile(userId);
      if (rowData.data == null) {
        emit(OnLogOut());
        return;
      }
      final userData = UserInfo.fromJson(rowData.data);

      if (userData.status == userBlocked) {
        print("blocked");
      }

      emit(UserActive(userInfo: userData));
    } on DioError catch (e) {
      emit(
          AuthDenied(error: e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik "));
      print(e);
    }
  }

  Future<void> authSignUp(
      String fullName, String phone, String password) async {
    emit(OnAuthProgress());

    try {
      final response = await _repo.sighUp(fullName, "998$phone", password);
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
    emit(OnAuthProgress());
    try {
      final response = await _repo.logIn(phone, password);
      await _storage.saveToken(response.data["user_auth"]);
      final userInfo = UserInfo.fromJson(response.data["user_info"]);
      await _storage.saveUserId(userInfo.id!);
      print("from storage: ${await _storage.getToken()}");
      print("from storage: ${await _storage.getUserId()}");
      emit(UserActive(userInfo: userInfo));
    } on DioError catch (e) {
      // if (e.response?.data["code"] == 0) {
      //   emit(OnAuthBlocked(message: e.response?.data["message"]));
      // }
      emit(
          AuthDenied(error: e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> refreshSmsCode(String phone) async {
    var userId = await _storage.getUserId();
    try {
      await _repo.refreshSmsCode(userId!, phone);
    } on DioError catch (e) {
      emit(
          AuthDenied(error: e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }

  Future<void> checkSmsCode(int userId, String phone, String smsCode) async {
    emit(OnAuthProgress());
    try {
      await _repo.checkRegisterSmsCode(userId, phone, smsCode);
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
          await _repo.checkForgotPasswordSmsCode(userId, realPhone, smsCode);
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
    var userId = await _storage.getUserId();
    var authKey = await _storage.getToken();
    try {
      await _repo.logOut(userId!, authKey!);
      emit(OnLogOut());
      await _storage.clearToken();
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
      final response = await _repo.forgotPassword(realPhone);
      final userId = response.data["id"];
      final authKey = response.data["auth_key"];

      await _storage.saveUserId(userId);
      await _storage.saveToken(authKey);

      showToast(response.data["message"]);
      emit(AuthOnSMS(id: userId, phoneNumber: phone));
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
    final userId = await _storage.getUserId();
    final authKey = await _storage.getToken();

    try {
      final response = await _repo.changePassword(
          userId!, authKey!, phone, newPassword, confirmPassword);
      showToast(response.data["message"]);
      emit(AuthGranted());
    } on DioError catch (e) {
      emit(AuthDenied(error: e.response?.data["message"] ?? ""));
    } catch (e) {
      emit(const AuthDenied(error: "Tizimda nosozlik"));
    }
  }
}
