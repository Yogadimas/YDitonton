import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TVWatchlistBloc extends Bloc<TVWatchlistEvent, TVWatchlistState> {
  final GetWatchlistStatusTV _getWatchlistStatus;
  final SaveWatchlistTV _saveWatchlist;
  final RemoveWatchlistTV _removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TVWatchlistBloc(
    this._getWatchlistStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(TVWatchlistStatus(false)) {
    on<LoadWatchlistStatus>((event, emit) async {
      final result = await _getWatchlistStatus.execute(event.id);
      emit(TVWatchlistStatus(result));
    });

    on<AddTVToWatchlist>((event, emit) async {
      final result = await _saveWatchlist.execute(event.tv);
      result.fold(
        (failure) => emit(TVWatchlistError(failure.message)),
        (successMessage) => emit(TVWatchlistMessage(successMessage)),
      );
      add(LoadWatchlistStatus(event.tv.id));
    });

    on<RemoveTVFromWatchlist>((event, emit) async {
      final result = await _removeWatchlist.execute(event.tv);
      result.fold(
        (failure) => emit(TVWatchlistError(failure.message)),
        (successMessage) => emit(TVWatchlistMessage(successMessage)),
      );
      add(LoadWatchlistStatus(event.tv.id));
    });
  }
}
