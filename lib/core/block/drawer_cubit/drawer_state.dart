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
