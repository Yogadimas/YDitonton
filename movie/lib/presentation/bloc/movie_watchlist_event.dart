part of 'movie_watchlist_bloc.dart';

abstract class MovieWatchlistEvent extends Equatable {
  const MovieWatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlistStatus extends MovieWatchlistEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends MovieWatchlistEvent {
  final MovieDetail movie;

  const AddMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends MovieWatchlistEvent {
  final MovieDetail movie;

  const RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
