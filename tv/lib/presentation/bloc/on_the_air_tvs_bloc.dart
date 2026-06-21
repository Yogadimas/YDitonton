import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';

part 'on_the_air_tvs_event.dart';
part 'on_the_air_tvs_state.dart';

class OnTheAirTVsBloc extends Bloc<OnTheAirTVsEvent, OnTheAirTVsState> {
  final GetOnTheAirTVs _usecase;

  OnTheAirTVsBloc(this._usecase) : super(OnTheAirTVsEmpty()) {
    on<FetchOnTheAirTVs>((event, emit) async {
      emit(OnTheAirTVsLoading());
      final result = await _usecase.execute();
      result.fold(
        (failure) => emit(OnTheAirTVsError(failure.message)),
        (data) => emit(OnTheAirTVsHasData(data)),
      );
    });
  }
}
