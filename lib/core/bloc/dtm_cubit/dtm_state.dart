part of 'dtm_cubit.dart';

abstract class DtmState extends Equatable {
  const DtmState();

  @override
  List<Object> get props => [];
}

class DtmInitial extends DtmState {}

class OnDtmTestProgress extends DtmState {}

class OnDtmTestReceived extends DtmState {
  final Subjects subjectData;
  final List<Tests> testList;
  final bool isTestEnded = false;
  const OnDtmTestReceived(this.subjectData, this.testList, bool isTestEnded);
  @override
  List<Object> get props => [subjectData, testList];

  OnDtmTestReceived copyWith(List<Tests> newTestList) {
    return OnDtmTestReceived(subjectData, newTestList, isTestEnded);
  }

  OnDtmTestReceived changeBool(bool isTestEnd) {
    return OnDtmTestReceived(subjectData, testList, isTestEnd);
  }
}

class OnDtmTestError extends DtmState {
  final String error;
  const OnDtmTestError(this.error);
  @override
  List<Object> get props => [error];
}
