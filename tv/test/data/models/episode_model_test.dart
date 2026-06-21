import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/domain/entities/episode.dart';

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

  test('should be a subclass of Episode entity', () async {
    final result = tEpisodeModel.toEntity();
    expect(result, tEpisode);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": 1,
        "name": "name",
        "overview": "overview",
        "season_number": 1,
        "episode_number": 1,
        "still_path": "stillPath",
        "vote_average": 1.0,
        "vote_count": 1,
        "air_date": "2021-01-01",
      };
      // act
      final result = EpisodeModel.fromJson(jsonMap);
      // assert
      expect(result, tEpisodeModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tEpisodeModel.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": "name",
        "overview": "overview",
        "season_number": 1,
        "episode_number": 1,
        "still_path": "stillPath",
        "vote_average": 1.0,
        "vote_count": 1,
        "air_date": "2021-01-01",
      };
      expect(result, expectedJsonMap);
    });
  });
}
