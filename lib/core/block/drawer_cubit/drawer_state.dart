part of 'drawer_cubit.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {}

class DrawerSubId extends DrawerState {
  final int subId;

  const DrawerSubId(this.subId);

  @override
  List<Object> get props => [subId];
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
