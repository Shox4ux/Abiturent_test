part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class OnCardProgress extends PaymentState {}

class OnCardAdded extends PaymentState {}

class OnPaymentSent extends PaymentState {}

class OnCardsReceived extends PaymentState {
  final List<CardModel> cardList;
  const OnCardsReceived(this.cardList);
  @override
  List<Object> get props => [cardList];
}

class OnCardError extends PaymentState {
  final String error;
  const OnCardError(this.error);
  @override
  List<Object> get props => [error];
}
