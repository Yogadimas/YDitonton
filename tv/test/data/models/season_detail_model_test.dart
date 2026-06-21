import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/data/models/season_detail_model.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/domain/entities/season_detail.dart';

void main() {
  const tEpisodeModel = EpisodeModel(
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    episodeNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 1.0,
    voteCount: 1,
    airDate: '2021-01-01',
    crew: [],
    guestStars: [],
  );

  const tSeasonDetailModel = SeasonDetailModel(
    id: 1,
    airDate: '2021-01-01',
    episodes: [tEpisodeModel],
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
    voteAverage: 1.0,
  );

  const tEpisode = Episode(
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    episodeNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 1.0,
    voteCount: 1,
    airDate: '2021-01-01',
    crew: [],
    guestStars: [],
  );

  final tSeasonDetail = SeasonDetail(
    id: 1,
    airDate: '2021-01-01',
    episodes: [tEpisode],
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
    voteAverage: 1.0,
  );

  test('should be a subclass of SeasonDetail entity', () async {
    final result = tSeasonDetailModel.toEntity();
    expect(result, tSeasonDetail);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "air_date": "2021-01-01",
        "episodes": [
          {
            "id": 1,
            "name": "name",
            "overview": "overview",
            "season_number": 1,
            "episode_number": 1,
            "still_path": "stillPath",
            "vote_average": 1.0,
            "vote_count": 1,
            "air_date": "2021-01-01",
            "crew": [],
            "guest_stars": []
          }
        ],
        "name": "name",
        "overview": "overview",
        "poster_path": "posterPath",
        "season_number": 1,
        "vote_average": 1.0,
      };
      // act
      final result = SeasonDetailModel.fromJson(jsonMap);
      // assert
      expect(result, tSeasonDetailModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tSeasonDetailModel.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "air_date": "2021-01-01",
        "episodes": [
          {
            "id": 1,
            "name": "name",
            "overview": "overview",
            "season_number": 1,
            "episode_number": 1,
            "still_path": "stillPath",
            "vote_average": 1.0,
            "vote_count": 1,
            "air_date": "2021-01-01"
          }
        ],
        "name": "name",
        "overview": "overview",
        "poster_path": "posterPath",
        "season_number": 1,
        "vote_average": 1.0,
      };
      expect(result, expectedJsonMap);
    });
  });
}
