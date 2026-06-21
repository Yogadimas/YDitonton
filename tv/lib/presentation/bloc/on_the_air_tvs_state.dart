part of 'on_the_air_tvs_bloc.dart';

abstract class OnTheAirTVsState extends Equatable {
  const OnTheAirTVsState();

  @override
  List<Object> get props => [];
}

class OnTheAirTVsEmpty extends OnTheAirTVsState {}

class OnTheAirTVsLoading extends OnTheAirTVsState {}

class OnTheAirTVsError extends OnTheAirTVsState {
  final String message;

  const OnTheAirTVsError(this.message);

  @override
  List<Object> get props => [message];
}

class OnTheAirTVsHasData extends OnTheAirTVsState {
  final List<TV> result;

  const OnTheAirTVsHasData(this.result);

  @override
  List<Object> get props => [result];
}
