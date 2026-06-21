import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';

part 'season_detail_event.dart';
part 'season_detail_state.dart';

class SeasonDetailBloc extends Bloc<SeasonDetailEvent, SeasonDetailState> {
  final GetTVSeasonDetail _usecase;

  SeasonDetailBloc(this._usecase) : super(SeasonDetailEmpty()) {
    on<FetchSeasonDetail>((event, emit) async {
      emit(SeasonDetailLoading());
      final result = await _usecase.execute(event.id, event.seasonNumber);
      result.fold(
        (failure) => emit(SeasonDetailError(failure.message)),
        (data) => emit(SeasonDetailHasData(data)),
      );
    });
  }
}
