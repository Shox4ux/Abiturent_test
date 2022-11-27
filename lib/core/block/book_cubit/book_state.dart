part of 'book_cubit.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}

class OnDownloadCompleted extends BookState {}

class OnProgress extends BookState {
  final double progress;
  const OnProgress(this.progress);
  @override
  List<Object> get props => [progress];
}

class OnError extends BookState {
  final String error;
  const OnError(this.error);
  @override
  List<Object> get props => [error];
}
