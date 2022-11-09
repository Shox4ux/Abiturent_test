import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/core/domain/subject_models/subject_model.dart';
import 'package:test_app/core/helper/repos/group_repo.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  final _repo = GroupRepo();

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
    } catch (e) {
      emit(OnError(e.toString()));
    }
  }

  void deleteMember(int userId, int memberId) async {
    emit(OnProgress());
    try {
      final response = await _repo.deleteGroupMember(userId, memberId);
      emit(OnSuccess());
    } catch (e) {
      emit(OnError(e.toString()));
    }
  }
}
