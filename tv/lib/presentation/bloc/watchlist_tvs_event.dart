part of 'watchlist_tvs_bloc.dart';

abstract class WatchlistTVsEvent extends Equatable {
  const WatchlistTVsEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTVs extends WatchlistTVsEvent {}
