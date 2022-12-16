part of 'drawer_cubit.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {}

class DrawerSubjectsLoadedState extends DrawerState {
  final int index;
  final List<SubjectModel> subList;
  const DrawerSubjectsLoadedState({
    required this.index,
    required this.subList,
  });

  DrawerSubjectsLoadedState copyWith({
    int? index,
    List<SubjectModel>? subList,
  }) {
    return DrawerSubjectsLoadedState(
      index: index ?? this.index,
      subList: subList ?? this.subList,
    );
  }

  @override
  List<Object> get props => [index, subList];
}

class DrawerSubId extends DrawerState {
  final int subId;
  const DrawerSubId(this.subId);
  @override
  List<Object> get props => [subId];
}

class DrawerIndex extends DrawerState {
  final int index;
  const DrawerIndex(this.index);
  @override
  List<Object> get props => [index];
}

class OnDrawerProgress extends DrawerState {}

class OnDrawerSubsReceived extends DrawerState {
  final List<SubjectModel> subList;
  const OnDrawerSubsReceived(this.subList);
  @override
  List<Object> get props => [subList];
}

class OnDrawerError extends DrawerState {
  final String error;

  const OnDrawerError(this.error);

  @override
  List<Object> get props => [error];
}
