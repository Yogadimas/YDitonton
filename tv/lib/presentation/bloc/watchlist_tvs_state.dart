part of 'watchlist_tvs_bloc.dart';

abstract class WatchlistTVsState extends Equatable {
  const WatchlistTVsState();

  @override
  List<Object> get props => [];
}

class WatchlistTVsEmpty extends WatchlistTVsState {}

class WatchlistTVsLoading extends WatchlistTVsState {}

class WatchlistTVsError extends WatchlistTVsState {
  final String message;

  const WatchlistTVsError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTVsHasData extends WatchlistTVsState {
  final List<TV> result;

  const WatchlistTVsHasData(this.result);

  @override
  List<Object> get props => [result];
}
