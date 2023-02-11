part of 'statistics_cubit.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class OnStatsProgress extends StatisticsState {}

class OnStatsEmpty extends StatisticsState {}

class OnStatsSuccess extends StatisticsState {
  final List<StatModel> statsList;

  const OnStatsSuccess(this.statsList);
  @override
  List<Object> get props => [];
}

class OnStatsError extends StatisticsState {
  final String message;

  const OnStatsError(this.message);
  @override
  List<Object> get props => [];
}
