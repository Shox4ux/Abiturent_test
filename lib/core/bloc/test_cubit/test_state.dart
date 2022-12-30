part of 'test_cubit.dart';

abstract class TestState extends Equatable {
  const TestState();
  @override
  List<Object> get props => [];
}

class TestInitial extends TestState {}

class OnTestProgress extends TestState {
  @override
  List<Object> get props => [];
}

class OnTestInnerSuccess extends TestState {
  final InnerTestModel innerTest;
  const OnTestInnerSuccess(this.innerTest);
  @override
  List<Object> get props => [innerTest];
}

class OnTestError extends TestState {
  final String error;
  const OnTestError(this.error);
  @override
  List<Object> get props => [error];
}

class OnCelebrate extends TestState {
  final int testListId;
  const OnCelebrate(this.testListId);
  @override
  List<Object> get props => [testListId];
}

class OnTestCompleted extends TestState {
  final List<TestResult> resultTest;
  const OnTestCompleted(this.resultTest);
  @override
  List<Object> get props => [resultTest];
}

class OnTestSuccess extends TestState {
  final Subjects subjectData;
  final List<Tests> testList;
  final List<Books> bookList;

  const OnTestSuccess({
    required this.subjectData,
    required this.testList,
    required this.bookList,
  });

  OnTestSuccess copyWith(List<Tests>? newTestList) {
    return OnTestSuccess(
        subjectData: subjectData, testList: newTestList!, bookList: bookList);
  }

  @override
  List<Object> get props => [subjectData, testList, bookList];
}