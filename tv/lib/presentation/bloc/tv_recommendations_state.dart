part of 'tv_recommendations_bloc.dart';

abstract class TVRecommendationsState extends Equatable {
  const TVRecommendationsState();

  @override
  List<Object> get props => [];
}

class TVRecommendationsEmpty extends TVRecommendationsState {}

class TVRecommendationsLoading extends TVRecommendationsState {}

class TVRecommendationsError extends TVRecommendationsState {
  final String message;

  const TVRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class TVRecommendationsHasData extends TVRecommendationsState {
  final List<TV> result;

  const TVRecommendationsHasData(this.result);

  @override
  List<Object> get props => [result];
}
