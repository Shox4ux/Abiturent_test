part of 'rating_cubit.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

class RatingInitial extends RatingState {}

class OnRatingProgress extends RatingState {}

class OnRatingEmpty extends RatingState {}

class OnRatingReceived extends RatingState {
  final RatingModel ratingModel;
  const OnRatingReceived(this.ratingModel);
  @override
  List<Object> get props => [ratingModel];
}

class OnRatingError extends RatingState {
  final String error;
  const OnRatingError({required this.error});
  @override
  List<Object> get props => [error];
}
