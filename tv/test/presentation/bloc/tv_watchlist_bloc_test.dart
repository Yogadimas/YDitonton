import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_watchlist_bloc.dart';

import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistStatusTV, SaveWatchlistTV, RemoveWatchlistTV])
void main() {
  late TVWatchlistBloc bloc;
  late MockGetWatchlistStatusTV mockGetWatchlistStatusTV;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;

  setUp(() {
    mockGetWatchlistStatusTV = MockGetWatchlistStatusTV();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    bloc = TVWatchlistBloc(
      mockGetWatchlistStatusTV,
      mockSaveWatchlistTV,
      mockRemoveWatchlistTV,
    );
  });

  test('initial state should be status false', () {
    expect(bloc.state, TVWatchlistStatus(false));
  });

  final tTVDetail = TVDetail(
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

  blocTest<TVWatchlistBloc, TVWatchlistState>(
    'Should emit [Status] when load status is called',
    build: () {
      when(mockGetWatchlistStatusTV.execute(1)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistStatus(1)),
    expect: () => [
      TVWatchlistStatus(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistStatusTV.execute(1));
    },
  );

  blocTest<TVWatchlistBloc, TVWatchlistState>(
    'Should emit [Message, Status] when add watchlist is successful',
    build: () {
      when(mockSaveWatchlistTV.execute(tTVDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatusTV.execute(1)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(AddTVToWatchlist(tTVDetail)),
    expect: () => [
      TVWatchlistMessage('Added to Watchlist'),
      TVWatchlistStatus(true),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTV.execute(tTVDetail));
      verify(mockGetWatchlistStatusTV.execute(1));
    },
  );

  blocTest<TVWatchlistBloc, TVWatchlistState>(
    'Should emit [Error, Status] when add watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlistTV.execute(tTVDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      when(mockGetWatchlistStatusTV.execute(1)).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(AddTVToWatchlist(tTVDetail)),
    expect: () => [
      TVWatchlistError('Database Failure'),
      TVWatchlistStatus(false),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTV.execute(tTVDetail));
      verify(mockGetWatchlistStatusTV.execute(1));
    },
  );

  blocTest<TVWatchlistBloc, TVWatchlistState>(
    'Should emit [Message, Status] when remove watchlist is successful',
    build: () {
      when(mockRemoveWatchlistTV.execute(tTVDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchlistStatusTV.execute(1)).thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveTVFromWatchlist(tTVDetail)),
    expect: () => [
      TVWatchlistMessage('Removed from Watchlist'),
      TVWatchlistStatus(false),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTV.execute(tTVDetail));
      verify(mockGetWatchlistStatusTV.execute(1));
    },
  );
}
