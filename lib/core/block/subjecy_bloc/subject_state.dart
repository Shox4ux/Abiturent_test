part of 'subject_cubit.dart';

abstract class SubjectState extends Equatable {
  const SubjectState();

  @override
  List<Object> get props => [];
}

class SubjectInitial extends SubjectState {}

class OnSubReceived extends SubjectState {
  final List<SubjectModel> list;
  const OnSubReceived({required this.list});
  @override
  List<Object> get props => [list];
}

class OnSubMove extends SubjectState {
  @override
  List<Object> get props => [];
}

class SubId extends SubjectState {
  final int id;
  const SubId(this.id);
  @override
  List<Object> get props => [id];
}

class OnSubError extends SubjectState {
  final String error;
  const OnSubError({required this.error});
  @override
  List<Object> get props => [error];
}
