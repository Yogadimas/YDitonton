import 'dart:io';

import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:tv/domain/entities/tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVModel = TVModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTV = TV(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Spider-Man',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTVModelList = <TVModel>[tTVModel];
  final tTVList = <TV>[tTV];

  group('Now Playing TVs', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTVs(),
        ).thenAnswer((_) async => tTVModelList);
        // act
        final result = await repository.getOnTheAirTVs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTVs());

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTVs(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTVs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTVs());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getOnTheAirTVs(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getOnTheAirTVs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTVs());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular TVs', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(
        mockRemoteDataSource.getPopularTVs(),
      ).thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getPopularTVs();
      // assert

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTVs()).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTVs();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getPopularTVs(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTVs();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TVs', () {
    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTVs(),
        ).thenAnswer((_) async => tTVModelList);
        // act
        final result = await repository.getTopRatedTVs();
        // assert

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTVs(),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTVs();
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTopRatedTVs(),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTVs();
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Detail', () {
    final tId = 1;
    final tTVResponse = TVDetailResponse(
      backdropPath: 'backdropPath',
      genres: [],
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      name: 'name',
      voteAverage: 1,
      voteCount: 1,
      seasons: [],
    );

    test(
      'should return TV data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVDetail(tId),
        ).thenAnswer((_) async => tTVResponse);
        // act
        final result = await repository.getTVDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTVDetail(tId));
        expect(result, equals(Right(tTVDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVDetail(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTVDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTVDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTVDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Season Detail', () {
    final tId = 1;
    final tSeasonNumber = 1;

    test(
      'should return TV season data when the call to remote data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber),
        ).thenAnswer((_) async => tSeasonDetailModel);
        // act
        final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
        // assert
        verify(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber));
        expect(result, equals(Right(tSeasonDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
        // assert
        verify(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVSeasonDetail(tId, tSeasonNumber);
        // assert
        verify(mockRemoteDataSource.getTVSeasonDetail(tId, tSeasonNumber));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Recommendations', () {
    final tTVList = <TVModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      // arrange
      when(
        mockRemoteDataSource.getTVRecommendations(tId),
      ).thenAnswer((_) async => tTVList);
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));

      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTVList));
    });

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVRecommendations(tId),
        ).thenThrow(ServerException());
        // act
        final result = await repository.getTVRecommendations(tId);
        // assertbuild runner
        verify(mockRemoteDataSource.getTVRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.getTVRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTVRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTVRecommendations(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Seach TVs', () {
    final tQuery = 'spiderman';

    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTVs(tQuery),
        ).thenAnswer((_) async => tTVModelList);
        // act
        final result = await repository.searchTVs(tQuery);
        // assert

        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVList);
      },
    );

    test(
      'should return ServerFailure when call to data source is unsuccessful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTVs(tQuery),
        ).thenThrow(ServerException());
        // act
        final result = await repository.searchTVs(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      },
    );

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(
          mockRemoteDataSource.searchTVs(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTVs(tQuery);
        // assert
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(tTVTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTV(tTVDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.insertWatchlist(tTVTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistTV(tTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(tTVTable),
      ).thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTV(tTVDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(
        mockLocalDataSource.removeWatchlist(tTVTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTV(tTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTV(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TVs', () async {
      // arrange
      when(
        mockLocalDataSource.getWatchlistTVs(),
      ).thenAnswer((_) async => [tTVTable]);
      // act
      final result = await repository.getWatchlistTVs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [tWatchlistTV]);
    });
  });
}
