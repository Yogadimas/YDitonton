import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatus, SaveWatchlist, RemoveWatchlist])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieWatchlistBloc = MovieWatchlistBloc(
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  test('initial state should be status false', () {
    expect(movieWatchlistBloc.state, MovieWatchlistStatus(false));
  });

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final tId = 1;

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Status] when load status is called',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
    expect: () => [
      MovieWatchlistStatus(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Message, Status] when add movie is successful',
    build: () {
      when(mockSaveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddMovieToWatchlist(tMovieDetail)),
    expect: () => [
      MovieWatchlistMessage('Added to Watchlist'),
      MovieWatchlistStatus(true),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(tMovieDetail));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Error, Status] when add movie is unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddMovieToWatchlist(tMovieDetail)),
    expect: () => [
      MovieWatchlistError('Database Failure'),
      MovieWatchlistStatus(false),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(tMovieDetail));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Message, Status] when remove movie is successful',
    build: () {
      when(mockRemoveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveMovieFromWatchlist(tMovieDetail)),
    expect: () => [
      MovieWatchlistMessage('Removed from Watchlist'),
      MovieWatchlistStatus(false),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(tMovieDetail));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Error, Status] when remove movie is unsuccessful',
    build: () {
      when(mockRemoveWatchlist.execute(tMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveMovieFromWatchlist(tMovieDetail)),
    expect: () => [
      MovieWatchlistError('Database Failure'),
      MovieWatchlistStatus(true),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(tMovieDetail));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );
}
