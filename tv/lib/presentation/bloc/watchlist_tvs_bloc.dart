import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';

part 'watchlist_tvs_event.dart';
part 'watchlist_tvs_state.dart';

class WatchlistTVsBloc extends Bloc<WatchlistTVsEvent, WatchlistTVsState> {
  final GetWatchlistTVs _usecase;

  WatchlistTVsBloc(this._usecase) : super(WatchlistTVsEmpty()) {
    on<FetchWatchlistTVs>((event, emit) async {
      emit(WatchlistTVsLoading());
      final result = await _usecase.execute();
      result.fold(
        (failure) => emit(WatchlistTVsError(failure.message)),
        (data) => emit(WatchlistTVsHasData(data)),
      );
    });
  }
}
