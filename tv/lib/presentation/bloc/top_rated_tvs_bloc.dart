import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';

part 'top_rated_tvs_event.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTVsBloc extends Bloc<TopRatedTVsEvent, TopRatedTVsState> {
  final GetTopRatedTVs _usecase;

  TopRatedTVsBloc(this._usecase) : super(TopRatedTVsEmpty()) {
    on<FetchTopRatedTVs>((event, emit) async {
      emit(TopRatedTVsLoading());
      final result = await _usecase.execute();
      result.fold(
        (failure) => emit(TopRatedTVsError(failure.message)),
        (data) => emit(TopRatedTVsHasData(data)),
      );
    });
  }
}
