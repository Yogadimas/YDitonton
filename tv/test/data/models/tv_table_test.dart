import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

void main() {
  final tTVTable = TVTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

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

  final tTV = TV.watchlist(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tTVTableMap = {
    'id': 1,
    'name': 'name',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  group('TVTable', () {
    test('should return a valid model from Map', () async {
      // act
      final result = TVTable.fromMap(tTVTableMap);
      // assert
      expect(result, tTVTable);
    });

    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTVTable.toJson();
      // assert
      expect(result, tTVTableMap);
    });

    test('should be a subclass of TV entity', () async {
      // act
      final result = tTVTable.toEntity();
      // assert
      expect(result, tTV);
    });

    test('should be a subclass of TVTable from Entity', () async {
      // act
      final result = TVTable.fromEntity(tTVDetail);
      // assert
      expect(result.id, tTVDetail.id);
      expect(result.name, tTVDetail.name);
      expect(result.posterPath, tTVDetail.posterPath);
      expect(result.overview, tTVDetail.overview);
    });
  });
}
