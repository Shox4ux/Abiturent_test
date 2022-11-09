part of 'group_cubit.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupInitial extends GroupState {}

class OnProgress extends GroupState {
  @override
  List<Object> get props => [];
}

class OnSuccess extends GroupState {
  @override
  List<Object> get props => [];
}

class OnError extends GroupState {
  final String error;

  const OnError(this.error);

  @override
  List<Object> get props => [error];
}
