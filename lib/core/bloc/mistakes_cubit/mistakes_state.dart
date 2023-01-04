part of 'mistakes_cubit.dart';

abstract class MistakesState extends Equatable {
  const MistakesState();

  @override
  List<Object> get props => [];
}

class MistakesInitial extends MistakesState {}

class OnMistakesProgress extends MistakesState {}

class OnMistakesEmpty extends MistakesState {
  final String subjectName;

  const OnMistakesEmpty(this.subjectName);
  @override
  List<Object> get props => [subjectName];
}

class OnMistakesReceived extends MistakesState {
  final MistakesModel mistakesModel;
  const OnMistakesReceived(this.mistakesModel);
  @override
  List<Object> get props => [mistakesModel];
}

class OnMistakesError extends MistakesState {
  final String error;
  const OnMistakesError(this.error);
  @override
  List<Object> get props => [error];
}
