part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class OnCardProgress extends PaymentState {}

class OnMadePayment extends PaymentState {
  final PaymentResponse paymentResponse;
  const OnMadePayment(this.paymentResponse);
  @override
  List<Object> get props => [paymentResponse];
}

class OnCardError extends PaymentState {
  final String error;
  const OnCardError(this.error);
  @override
  List<Object> get props => [error];
}

class OnPayHistoryProgress extends PaymentState {}

class OnPayHistoryReceived extends PaymentState {
  final List<PaymentHistory> list;
  const OnPayHistoryReceived(this.list);

  @override
  List<Object> get props => [list];
}

class OnPayHistoryError extends PaymentState {
  final String error;
  const OnPayHistoryError(this.error);

  @override
  List<Object> get props => [error];
}
