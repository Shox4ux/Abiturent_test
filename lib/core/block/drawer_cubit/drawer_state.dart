part of 'drawer_cubit.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {}

class DrawerSubjectsLoadedState extends DrawerState {
  final int index;
  final List<SubjectModel> subjectList;
  const DrawerSubjectsLoadedState(this.index, this.subjectList);
  @override
  List<Object> get props => [index, subjectList];

  DrawerSubjectsLoadedState copyWith(int? index) {
    return DrawerSubjectsLoadedState(index ?? this.index, subjectList);
  }
}

class OnDrawerProgress extends DrawerState {}

class OnDrawerError extends DrawerState {
  final String error;
  const OnDrawerError(this.error);
  @override
  List<Object> get props => [error];
}
