import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchListStatus _getWatchlistStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  MovieWatchlistBloc(
    this._getWatchlistStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(MovieWatchlistStatus(false)) {
    on<LoadWatchlistStatus>((event, emit) async {
      final result = await _getWatchlistStatus.execute(event.id);
      emit(MovieWatchlistStatus(result));
    });

    on<AddMovieToWatchlist>((event, emit) async {
      final result = await _saveWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(MovieWatchlistError(failure.message)),
        (successMessage) => emit(MovieWatchlistMessage(successMessage)),
      );
      add(LoadWatchlistStatus(event.movie.id));
    });

    on<RemoveMovieFromWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(MovieWatchlistError(failure.message)),
        (successMessage) => emit(MovieWatchlistMessage(successMessage)),
      );
      add(LoadWatchlistStatus(event.movie.id));
    });
  }
}
