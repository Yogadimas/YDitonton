import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:movie/domain/entities/movie_detail.dart';

void main() {
  test('Movie Events and States props should work', () {
    // Events
    expect(FetchNowPlayingMovies().props, []);
    expect(FetchPopularMovies().props, []);
    expect(FetchTopRatedMovies().props, []);
    expect(FetchWatchlistMovies().props, []);
    expect(FetchMovieDetail(1).props, [1]);
    expect(FetchMovieRecommendations(1).props, [1]);
    expect(LoadWatchlistStatus(1).props, [1]);

    final tMovieDetail = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 120,
      title: 'title',
      voteAverage: 1.0,
      voteCount: 1,
    );
    expect(AddMovieToWatchlist(tMovieDetail).props, [tMovieDetail]);
    expect(RemoveMovieFromWatchlist(tMovieDetail).props, [tMovieDetail]);

    // States (some simple ones)
    expect(MovieWatchlistStatus(true).props, [true]);
    expect(MovieWatchlistMessage('msg').props, ['msg']);
  });
}
