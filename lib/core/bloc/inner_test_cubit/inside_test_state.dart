part of 'inside_test_cubit.dart';

abstract class InsideTestState extends Equatable {
  const InsideTestState();
  @override
  List<Object> get props => [];
}

class InsideTestInitial extends InsideTestState {}

class OnInnerTestProgress extends InsideTestState {}

class OnTestInnerSuccess extends InsideTestState {
  final InnerTestModel innerTest;
  const OnTestInnerSuccess(this.innerTest);
  @override
  List<Object> get props => [innerTest];
}

class OnInnerTestError extends InsideTestState {
  final String error;
  const OnInnerTestError(this.error);
  @override
  List<Object> get props => [error];
}

class OnInnerTestCelebrate extends InsideTestState {
  final int testListId;
  const OnInnerTestCelebrate(this.testListId);
  @override
  List<Object> get props => [testListId];
}

class OnInnerTestCompleted extends InsideTestState {
  final List<TestResult> resultTest;
  const OnInnerTestCompleted(this.resultTest);
  @override
  List<Object> get props => [resultTest];
}
