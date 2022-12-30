part of 'rating_cubit.dart';

abstract class RatingState extends Equatable {
  const RatingState();

  @override
  List<Object> get props => [];
}

class RatingInitial extends RatingState {}

class OnRatingProgress extends RatingState {}

class OnRatingEmpty extends RatingState {
  final RatingModel ratingModel;
  const OnRatingEmpty(this.ratingModel);
  @override
  List<Object> get props => [ratingModel];
}

class OnRatingReceived extends RatingState {
  final RatingModel ratingModel;
  const OnRatingReceived(this.ratingModel);
  @override
  List<Object> get props => [ratingModel];
}

class OnRatingBySubjectReceived extends RatingState {
  final CommonRatingModel model;
  const OnRatingBySubjectReceived(this.model);
  @override
  List<Object> get props => [model];
}

class OnRatingError extends RatingState {
  final String error;
  const OnRatingError({required this.error});
  @override
  List<Object> get props => [error];
}
