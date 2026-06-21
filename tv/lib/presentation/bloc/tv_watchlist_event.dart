part of 'tv_watchlist_bloc.dart';

abstract class TVWatchlistEvent extends Equatable {
  const TVWatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistStatus extends TVWatchlistEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddTVToWatchlist extends TVWatchlistEvent {
  final TVDetail tv;

  const AddTVToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveTVFromWatchlist extends TVWatchlistEvent {
  final TVDetail tv;

  const RemoveTVFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
