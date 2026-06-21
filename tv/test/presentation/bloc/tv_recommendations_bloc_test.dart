import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/tv_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetTVRecommendations])
void main() {
  late TVRecommendationsBloc bloc;
  late MockGetTVRecommendations mockUsecase;

  setUp(() {
    mockUsecase = MockGetTVRecommendations();
    bloc = TVRecommendationsBloc(mockUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, TVRecommendationsEmpty());
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

  blocTest<TVRecommendationsBloc, TVRecommendationsState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute(1)).thenAnswer((_) async => Right(tTVList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTVRecommendations(1)),
    expect: () => [
      TVRecommendationsLoading(),
      TVRecommendationsHasData(tTVList),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute(1));
    },
  );

  blocTest<TVRecommendationsBloc, TVRecommendationsState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockUsecase.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTVRecommendations(1)),
    expect: () => [
      TVRecommendationsLoading(),
      TVRecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute(1));
    },
  );
}
