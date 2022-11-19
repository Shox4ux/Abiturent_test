part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class OnGroupTapped extends GroupState {
  final Group group;
  final int userId;
  const OnGroupTapped(this.group, this.userId);
  @override
  List<Object> get props => [group];
}

class OnProgress extends GroupState {
  @override
  List<Object> get props => [];
}

class OnSuccess extends GroupState {}

class OnGroupAdded extends GroupState {
  final GroupModel model;
  final int userId;

  const OnGroupAdded(this.model, this.userId);
  @override
  List<Object> get props => [model];
}

class OnGroupsReceived extends GroupState {
  final List<GroupItem> groupList;

  const OnGroupsReceived(this.groupList);

  @override
  List<Object> get props => [groupList];
}

class OnError extends GroupState {
  final String error;

  const OnError(this.error);

  @override
  List<Object> get props => [error];
}

class OnGroupMembersReceived extends GroupState {
  final List<GroupMemberModel> membersList;
  const OnGroupMembersReceived(this.membersList);
  @override
  List<Object> get props => [membersList];
}
