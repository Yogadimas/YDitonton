import 'package:core/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/season_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/domain/entities/tv_detail.dart';

void main() {
  final tTVDetailResponse = TVDetailResponse(
    backdropPath: 'backdropPath',
    genres: [GenreModel(id: 1, name: 'Action')],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: '2022-01-01',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
    seasons: [
      SeasonModel(
        airDate: '2022-01-01',
        episodeCount: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
      ),
    ],
  );

  final tTVDetail = TVDetail(
    backdropPath: 'backdropPath',
    genres: [GenreModel(id: 1, name: 'Action').toEntity()],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    firstAirDate: '2022-01-01',
    name: 'name',
    voteAverage: 1.0,
    voteCount: 1,
    seasons: [
      SeasonModel(
        airDate: '2022-01-01',
        episodeCount: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
      ).toEntity(),
    ],
  );

  final tJson = {
    'backdrop_path': 'backdropPath',
    'genres': [
      {'id': 1, 'name': 'Action'},
    ],
    'id': 1,
    'original_name': 'originalName',
    'overview': 'overview',
    'poster_path': 'posterPath',
    'first_air_date': '2022-01-01',
    'name': 'name',
    'vote_average': 1.0,
    'vote_count': 1,
    'seasons': [
      {
        'air_date': '2022-01-01',
        'episode_count': 1,
        'id': 1,
        'name': 'name',
        'overview': 'overview',
        'poster_path': 'posterPath',
        'season_number': 1,
      },
    ],
  };

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // act
      final result = TVDetailResponse.fromJson(tJson);
      // assert
      expect(result, tTVDetailResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTVDetailResponse.toJson();
      // assert
      expect(result, tJson);
    });
  });

  group('toEntity', () {
    test('should be a subclass of TVDetail entity', () async {
      final result = tTVDetailResponse.toEntity();
      expect(result, tTVDetail);
    });
  });
}
