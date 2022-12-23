part of 'mistakes_cubit.dart';

abstract class MistakesState extends Equatable {
  const MistakesState();

  @override
  List<Object> get props => [];
}

class MistakesInitial extends MistakesState {}

class OnMistakesProgress extends MistakesState {}

class OnMistakesEmpty extends MistakesState {}

class OnMistakesReceived extends MistakesState {
  final List<TestResult> errorList;
  const OnMistakesReceived(this.errorList);
  @override
  List<Object> get props => [errorList];
}

class OnMistakesError extends MistakesState {
  final String error;
  const OnMistakesError(this.error);
  @override
  List<Object> get props => [error];
}
