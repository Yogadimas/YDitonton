import 'package:core/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_detail_model.dart';

void main() {
  final tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    budget: 100,
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://google.com',
    id: 1,
    imdbId: 'imdb1',
    originalLanguage: 'en',
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    revenue: 12000,
    runtime: 120,
    status: 'Status',
    tagline: 'Tagline',
    title: 'title',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tMovieDetailResponseJson = {
    "adult": false,
    "backdrop_path": "backdropPath",
    "budget": 100,
    "genres": [
      {"id": 1, "name": "Action"},
    ],
    "homepage": "https://google.com",
    "id": 1,
    "imdb_id": "imdb1",
    "original_language": "en",
    "original_title": "originalTitle",
    "overview": "overview",
    "popularity": 1.0,
    "poster_path": "posterPath",
    "release_date": "releaseDate",
    "revenue": 12000,
    "runtime": 120,
    "status": "Status",
    "tagline": "Tagline",
    "title": "title",
    "video": false,
    "vote_average": 1.0,
    "vote_count": 1,
  };

  group('MovieDetailResponse', () {
    test('should return a valid model from JSON', () {
      // act
      final result = MovieDetailResponse.fromJson(tMovieDetailResponseJson);
      // assert
      expect(result, tMovieDetailResponse);
    });

    test('should return a JSON map containing proper data', () {
      // act
      final result = tMovieDetailResponse.toJson();
      // assert
      expect(result, tMovieDetailResponseJson);
    });
  });
}
