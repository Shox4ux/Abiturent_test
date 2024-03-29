part of 'news_cubit.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class OnInnerNewsReceived extends NewsState {
  final MainNewsModel model;

  const OnInnerNewsReceived({required this.model});

  @override
  List<Object> get props => [model];
}

class OnNewsReceived extends NewsState {
  final List<NewsWithNotificationModel> newsList;
  final bool shouldNotifyProfile;

  const OnNewsReceived({
    required this.newsList,
    required this.shouldNotifyProfile,
  });

  @override
  List<Object> get props => [newsList, shouldNotifyProfile];
}

class OnNewsError extends NewsState {
  final String message;

  const OnNewsError({required this.message});
  @override
  List<Object> get props => [message];
}

class OnNewsProgress extends NewsState {}
