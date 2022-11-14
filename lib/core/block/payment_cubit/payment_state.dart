part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class OnHistoryProgress extends PaymentState {}

class OnHistorySuccess extends PaymentState {
  final List<PaymentHistory> historyList;

  const OnHistorySuccess(this.historyList);
  @override
  List<Object> get props => [historyList];
}

class OnHistoryError extends PaymentState {
  final String error;

  const OnHistoryError(this.error);

  @override
  List<Object> get props => [error];
}
