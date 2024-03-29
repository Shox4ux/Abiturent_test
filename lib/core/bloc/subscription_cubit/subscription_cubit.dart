import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/subscription_model/made_script.dart';
import 'package:test_app/core/domain/subscription_model/script_preview.dart';
import 'package:test_app/core/domain/subscription_model/subscription_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/script_repo.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial());

  final _repo = ScriptRepo();
  final _storage = AppStorage();

  Future<void> getScripts() async {
    emit(OnScriptProgress());
    final userId = await _storage.getUserId();
    try {
      final response = await _repo.getScripts(userId!);
      final rowData = response.data as List;
      final rowList =
          rowData.map((e) => SubscriptionModel.fromJson(e)).toList();
      emit(OnReceivedScript(rowList));
    } on DioError catch (e) {
      emit(OnScriptError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnScriptError("Tizimda nosozlik"));
    }
  }

  Future<void> getPreview(int subId) async {
    emit(OnScriptProgress());
    try {
      final response = await _repo.getPreviewScript(subId);

      final rowData = ScriptPreview.fromJson(response.data);
      emit(OnSubscriptionPreview(rowData));
    } on DioError catch (e) {
      emit(OnScriptError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(OnScriptError(e.message));
    } catch (e) {
      emit(const OnScriptError("Tizimda nosozlik"));
    }
  }

  Future<void> makeScript(int subId) async {
    emit(OnScriptProgress());
    final userId = await _storage.getUserId();
    final token = await _storage.getToken();
    try {
      final response = await _repo.makeScript(userId!, token!, subId);

      final rowData = MadeScript.fromJson(response.data);
      emit(OnScriptMade(rowData));
    } on DioError catch (e) {
      emit(OnScriptError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(OnScriptError(e.message));
    } catch (e) {
      emit(const OnScriptError("Tizimda nosozlik"));
    }
  }
}
