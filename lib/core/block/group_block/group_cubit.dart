import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:test_app/core/domain/group_model/group_member_model.dart';
import 'package:test_app/core/domain/group_model/group_model.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/core/helper/database/app_storage.dart';
import 'package:test_app/core/helper/repos/group_repo.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  final _repo = GroupRepo();
  final _storage = AppStorage();

  Future<void> creatGroup(int userId, String subName,
      List<SubjectModel> subList, String groupTitle) async {
    int? subjectId;

    for (var y in subList) {
      if (y.name! == subName) {
        subjectId = y.id!;
      }
    }
    emit(OnProgress());
    try {
      final response = await _repo.createGroup(userId, subjectId!, groupTitle);
      emit(OnSuccess());
    } catch (e) {
      emit(OnError(e.toString()));
    }
  }

  void addMember(int memberId, int groupId) async {
    emit(OnProgress());
    try {
      final response = await _repo.addGroupMember(memberId, groupId);
      emit(OnSuccess());
    } on DioError catch (e) {
      emit(OnError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  void deleteMember(int userId, int memberId) async {
    emit(OnProgress());
    try {
      final response = await _repo.deleteGroupMember(userId, memberId);
      emit(OnSuccess());
    } on DioError catch (e) {
      emit(OnError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  Future<void> getGroupsByUserId() async {
    final u = await _storage.getUserInfo();

    var userId = u.id!;

    emit(OnProgress());

    try {
      final response = await _repo.getGroup(userId);

      final rowData = response.data as List;

      final rowList = rowData.map((e) => GroupModel.fromJson(e)).toList();

      emit(OnGroupsReceived(rowList));
    } on DioError catch (e) {
      emit(OnError(e.response!.data["message"]));
    } on SocketException catch (e) {
      emit(const OnError("Tarmoqda nosozlik"));
    } catch (e) {
      emit(const OnError("Tizimda nosozlik"));
    }
  }

  Future<void> getGroupMembers() async {}
}
