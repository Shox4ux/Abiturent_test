import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:test_app/core/domain/group_model/group_item.dart';
import 'package:test_app/core/domain/group_model/group_member_model.dart';
import 'package:test_app/core/domain/group_model/group_model.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/group_repo.dart';
import 'package:test_app/res/functions/show_toast.dart';
part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  final _repo = GroupRepo();
  final _storage = AppStorage();

  Future<void> creatGroup(
      String subName, List<SubjectModel> subList, String groupTitle) async {
    int? subjectId;
    emit(OnProgress());

    for (var y in subList) {
      if (y.name! == subName) {
        subjectId = y.id!;
      }
    }

    final userId = await _storage.getUserId();

    try {
      final response = await _repo.createGroup(userId!, subjectId!, groupTitle);

      final rowData = Group.fromJson(response.data["group"]);
      showToast(response.data["message"]);

      final isAdmin = userId == rowData.ownerId as int;
      emit(OnInsideGroup(rowData, isAdmin));
    } on DioError catch (e) {
      emit(OnError(e.response!.data["message"]));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  Future<void> addMember(String memberId, int groupId) async {
    emit(OnProgress());
    final userId = await _storage.getUserId();

    try {
      final response = await _repo.addGroupMember(memberId, groupId);
      final rowData = Group.fromJson(response.data["group"]);
      showToast(response.data["message"]);

      final isAdmin = userId == rowData.ownerId;
      emit(OnInsideGroup(rowData, isAdmin));
    } on DioError catch (e) {
      emit(OnError(e.response!.data["message"]));
      getGroupMembers(groupId);
    } on SocketException {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  Future<void> deleteMember(int userId, int memberId) async {
    emit(OnProgress());

    try {
      final response = await _repo.deleteGroupMember(userId, memberId);

      final rowData = Group.fromJson(response.data["group"]);

      showToast(response.data["message"]);
      final isAdmin = userId == rowData.ownerId;

      emit(OnInsideGroup(rowData, isAdmin));
    } on DioError catch (e) {
      emit(OnError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } on SocketException {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  Future<void> getGroupsByUserId() async {
    emit(OnProgress());
    final userId = await _storage.getUserId();
    try {
      final response = await _repo.getGroup(userId!);
      final rowData = response.data as List;
      final rowList = rowData.map((e) => GroupItem.fromJson(e)).toList();

      emit(OnGroupsReceived(rowList));
    } on DioError catch (e) {
      emit(OnError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  Future<void> getGroupMembers(int groupId) async {
    emit(OnProgress());
    final userId = await _storage.getUserId();
    try {
      final response = await _repo.getGroupMembers(groupId);
      final rowData = Group.fromJson(response.data);

      final isAdmin = userId == rowData.ownerId as int;
      emit(OnInsideGroup(rowData, isAdmin));
    } on DioError catch (e) {
      emit(OnError(e.response?.data["message"] ?? "Tizimda nosozlik"));
    } on SocketException {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }
}
