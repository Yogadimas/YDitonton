part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistStatus extends MovieWatchlistState {
  final bool isAdded;

  const MovieWatchlistStatus(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class MovieWatchlistMessage extends MovieWatchlistState {
  final String message;

  const MovieWatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistError extends MovieWatchlistState {
  final String message;

  const MovieWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}
