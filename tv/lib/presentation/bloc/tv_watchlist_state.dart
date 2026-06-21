part of 'tv_watchlist_bloc.dart';

abstract class TVWatchlistState extends Equatable {
  const TVWatchlistState();

  @override
  List<Object> get props => [];
}

class TVWatchlistStatus extends TVWatchlistState {
  final bool isAdded;

  const TVWatchlistStatus(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class TVWatchlistMessage extends TVWatchlistState {
  final String message;

  const TVWatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}

class TVWatchlistError extends TVWatchlistState {
  final String message;

  const TVWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}
