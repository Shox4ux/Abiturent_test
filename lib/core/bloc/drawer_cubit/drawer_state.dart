part of 'drawer_cubit.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {}

class DrawerSubjectsLoadedState extends DrawerState {
  final int selectedSubjectId;
  final int selectedSubjectIndex;
  final List<SubjectModel> subjectList;

  const DrawerSubjectsLoadedState(
    this.selectedSubjectIndex,
    this.subjectList,
    this.selectedSubjectId,
  );
  @override
  List<Object> get props =>
      [selectedSubjectIndex, subjectList, selectedSubjectId];

  DrawerSubjectsLoadedState copyWith(int subjectIndex, int subjectId) {
    return DrawerSubjectsLoadedState(subjectIndex, subjectList, subjectId);
  }
}

class OnDrawerProgress extends DrawerState {}

class OnDrawerError extends DrawerState {
  final String error;
  const OnDrawerError(this.error);
  @override
  List<Object> get props => [error];
}
