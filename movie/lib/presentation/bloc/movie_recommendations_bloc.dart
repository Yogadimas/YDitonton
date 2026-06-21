import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';

part 'movie_recommendations_event.dart';
part 'movie_recommendations_state.dart';

class MovieRecommendationsBloc
    extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationsBloc(this._getMovieRecommendations)
      : super(MovieRecommendationsEmpty()) {
    on<FetchMovieRecommendations>((event, emit) async {
      emit(MovieRecommendationsLoading());
      final result = await _getMovieRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(MovieRecommendationsError(failure.message)),
        (data) => emit(MovieRecommendationsHasData(data)),
      );
    });
  }
}
