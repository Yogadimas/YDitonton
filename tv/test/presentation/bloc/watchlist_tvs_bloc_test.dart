import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';

import 'watchlist_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTVs])
void main() {
  late WatchlistTVsBloc bloc;
  late MockGetWatchlistTVs mockUsecase;

  setUp(() {
    mockUsecase = MockGetWatchlistTVs();
    bloc = WatchlistTVsBloc(mockUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistTVsEmpty());
  });

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
  final tTVList = <TV>[tTV];

  blocTest<WatchlistTVsBloc, WatchlistTVsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTVList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTVs()),
    expect: () => [
      WatchlistTVsLoading(),
      WatchlistTVsHasData(tTVList),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute());
    },
  );

  blocTest<WatchlistTVsBloc, WatchlistTVsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockUsecase.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTVs()),
    expect: () => [
      WatchlistTVsLoading(),
      WatchlistTVsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute());
    },
  );
}
