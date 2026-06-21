import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';

part 'popular_tvs_event.dart';
part 'popular_tvs_state.dart';

class PopularTVsBloc extends Bloc<PopularTVsEvent, PopularTVsState> {
  final GetPopularTVs _usecase;

  PopularTVsBloc(this._usecase) : super(PopularTVsEmpty()) {
    on<FetchPopularTVs>((event, emit) async {
      emit(PopularTVsLoading());
      final result = await _usecase.execute();
      result.fold(
        (failure) => emit(PopularTVsError(failure.message)),
        (data) => emit(PopularTVsHasData(data)),
      );
    });
  }
}
