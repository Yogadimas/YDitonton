import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';

part 'tv_recommendations_event.dart';
part 'tv_recommendations_state.dart';

class TVRecommendationsBloc
    extends Bloc<TVRecommendationsEvent, TVRecommendationsState> {
  final GetTVRecommendations _usecase;

  TVRecommendationsBloc(this._usecase) : super(TVRecommendationsEmpty()) {
    on<FetchTVRecommendations>((event, emit) async {
      emit(TVRecommendationsLoading());
      final result = await _usecase.execute(event.id);
      result.fold(
        (failure) => emit(TVRecommendationsError(failure.message)),
        (data) => emit(TVRecommendationsHasData(data)),
      );
    });
  }
}
