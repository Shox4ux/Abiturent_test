part of 'app_bar_cubit.dart';

abstract class AppBarState extends Equatable {
  const AppBarState();

  @override
  List<Object> get props => [];
}

class AppBarInitial extends AppBarState {}

class OnAppBarRatingProgress extends AppBarState {}

class OnAppBarRatingReceived extends AppBarState {
  final CommonRatingModel model;
  const OnAppBarRatingReceived(this.model);
  @override
  List<Object> get props => [model];
}

class OnAppBarRatingError extends AppBarState {
  final String error;
  const OnAppBarRatingError({required this.error});
  @override
  List<Object> get props => [error];
}
