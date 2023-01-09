part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserCubitInitial extends UserState {}

class OnUserProgress extends UserState {}

class OnUserUpdated extends UserState {}

class OnUsersRatingReceived extends UserState {
  final RatingModel ratingModel;
  const OnUsersRatingReceived({required this.ratingModel});
  @override
  List<Object> get props => [ratingModel];
}

class OnUserError extends UserState {
  final String error;
  const OnUserError({required this.error});
  @override
  List<Object> get props => [error];
}

class UserForAppBar extends UserState {
  final String userRating;
  final String userRatingMonth;

  const UserForAppBar(this.userRating, this.userRatingMonth);

  @override
  List<Object> get props => [userRating, userRatingMonth];
}

class OnProflieUpdated extends UserState {
  final UserInfo updatedProfile;
  const OnProflieUpdated(this.updatedProfile);
  @override
  List<Object> get props => [updatedProfile];
}
