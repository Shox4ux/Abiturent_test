part of 'news_cubit.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class OnError extends NewsState {
  final String errorMessage;
  const OnError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class OnSuccess extends NewsState {
  final List<MainNewsModel> list;
  const OnSuccess({required this.list});
  @override
  List<Object> get props => [list];
}
