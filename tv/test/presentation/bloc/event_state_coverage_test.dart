import 'package:flutter_test/flutter_test.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/season_detail_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendations_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';

void main() {
  test('TV Events and States props should work', () {
    // Events
    expect(FetchOnTheAirTVs().props, []);
    expect(FetchPopularTVs().props, []);
    expect(FetchTopRatedTVs().props, []);
    expect(FetchWatchlistTVs().props, []);
    expect(FetchTVDetail(1).props, [1]);
    expect(FetchTVRecommendations(1).props, [1]);
    expect(FetchSeasonDetail(1, 1).props, [1, 1]);
    expect(LoadWatchlistStatus(1).props, [1]);

    final tTVDetail = TVDetail(
      backdropPath: 'backdropPath',
      genres: [],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: 'name',
      voteAverage: 1.0,
      voteCount: 1,
      seasons: [],
    );
    expect(AddTVToWatchlist(tTVDetail).props, [tTVDetail]);
    expect(RemoveTVFromWatchlist(tTVDetail).props, [tTVDetail]);

    // States (some simple ones)
    expect(TVWatchlistStatus(true).props, [true]);
    expect(TVWatchlistMessage('msg').props, ['msg']);
  });
}
