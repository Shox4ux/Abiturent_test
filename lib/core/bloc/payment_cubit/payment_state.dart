part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class OnCardsEmpty extends PaymentState {}

class OnCardProgress extends PaymentState {}

class OnCardConfirmed extends PaymentState {}

class OnCardSelected extends PaymentState {
  final CardModel model;
  const OnCardSelected(this.model);
  @override
  List<Object> get props => [model];
}

class OnCardDeleted extends PaymentState {
  final String message;
  const OnCardDeleted(this.message);
  @override
  List<Object> get props => [message];
}

class OnCardAdded extends PaymentState {
  final CardModel model;

  const OnCardAdded(this.model);

  @override
  List<Object> get props => [model];
}

class OnCardsReceived extends PaymentState {
  final List<CardListModel> models;

  const OnCardsReceived(this.models);
  @override
  List<Object> get props => [models];
}

class OnMadePayment extends PaymentState {
  final OnPaymentDone onPaymentDone;
  const OnMadePayment(this.onPaymentDone);
  @override
  List<Object> get props => [onPaymentDone];
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
