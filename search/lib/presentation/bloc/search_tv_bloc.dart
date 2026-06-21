import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/search_tvs.dart';

import 'search_tv_event.dart';
import 'search_tv_state.dart';

EventTransformer<T> debounceTv<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTVs _searchTv;

  SearchTvBloc(this._searchTv) : super(SearchTvEmpty()) {
    on<OnQueryChangedTv>(
      (event, emit) async {
        final query = event.query;

        emit(SearchTvLoading());

        final result = await _searchTv.execute(query);

        result.fold(
          (failure) {
            emit(SearchTvError(failure.message));
          },
          (data) {
            emit(SearchTvHasData(data));
          },
        );
      },
      transformer: debounceTv(const Duration(milliseconds: 500)),
    );
  }
}
