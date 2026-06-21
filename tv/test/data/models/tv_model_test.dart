import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/domain/entities/tv.dart';

void main() {
  final tTVModel = TVModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTV = TV(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of TV entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "backdrop_path": "backdropPath",
        "genre_ids": [1, 2, 3],
        "id": 1,
        "original_name": "originalName",
        "overview": "overview",
        "popularity": 1.0,
        "poster_path": "posterPath",
        "first_air_date": "firstAirDate",
        "name": "name",
        "vote_average": 1.0,
        "vote_count": 1,
      };
      // act
      final result = TVModel.fromJson(jsonMap);
      // assert
      expect(result, tTVModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final expectedJsonMap = {
        "backdrop_path": "backdropPath",
        "genre_ids": [1, 2, 3],
        "id": 1,
        "original_name": "originalName",
        "overview": "overview",
        "popularity": 1.0,
        "poster_path": "posterPath",
        "first_air_date": "firstAirDate",
        "name": "name",
        "vote_average": 1.0,
        "vote_count": 1,
      };
      // act
      final result = tTVModel.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
