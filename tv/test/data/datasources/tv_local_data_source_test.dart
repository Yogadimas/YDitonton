import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlistTV(tTVTable.toJson()),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertWatchlist(tTVTable);
        // assert
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.insertWatchlistTV(tTVTable.toJson()),
        ).thenThrow(Exception());
        // act
        final call = dataSource.insertWatchlist(tTVTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlistTV(tTVTable.toJson()),
        ).thenAnswer((_) async => 1);
        // act
        final result = await dataSource.removeWatchlist(tTVTable);
        // assert
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        // arrange
        when(
          mockDatabaseHelper.removeWatchlistTV(tTVTable.toJson()),
        ).thenThrow(Exception());
        // act
        final call = dataSource.removeWatchlist(tTVTable);
        // assert
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get TV Detail By Id', () {
    final tId = 1;

    test('should return TV Detail Table when data is found', () async {
      // arrange
      when(
        mockDatabaseHelper.getTVById(tId),
      ).thenAnswer((_) async => testTVMap);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, tTVTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTVById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TVTable from database', () async {
      // arrange
      when(
        mockDatabaseHelper.getWatchlistTVs(),
      ).thenAnswer((_) async => [testTVMap]);
      // act
      final result = await dataSource.getWatchlistTVs();
      // assert
      expect(result, [tTVTable]);
    });
  });
}
