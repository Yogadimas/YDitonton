import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_bloc.dart';

import 'on_the_air_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTVs])
void main() {
  late OnTheAirTVsBloc bloc;
  late MockGetOnTheAirTVs mockUsecase;

  setUp(() {
    mockUsecase = MockGetOnTheAirTVs();
    bloc = OnTheAirTVsBloc(mockUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, OnTheAirTVsEmpty());
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

  blocTest<OnTheAirTVsBloc, OnTheAirTVsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTVList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTVs()),
    expect: () => [
      OnTheAirTVsLoading(),
      OnTheAirTVsHasData(tTVList),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute());
    },
  );

  blocTest<OnTheAirTVsBloc, OnTheAirTVsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockUsecase.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTVs()),
    expect: () => [
      OnTheAirTVsLoading(),
      OnTheAirTVsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute());
    },
  );
}
