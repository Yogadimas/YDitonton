import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:tv/presentation/bloc/season_detail_bloc.dart';

import 'season_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTVSeasonDetail])
void main() {
  late SeasonDetailBloc bloc;
  late MockGetTVSeasonDetail mockUsecase;

  setUp(() {
    mockUsecase = MockGetTVSeasonDetail();
    bloc = SeasonDetailBloc(mockUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, SeasonDetailEmpty());
  });

  final tSeasonDetail = SeasonDetail(
    id: 1,
    airDate: 'airDate',
    episodes: [],
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
    voteAverage: 1,
  );

  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute(1, 1))
          .thenAnswer((_) async => Right(tSeasonDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchSeasonDetail(1, 1)),
    expect: () => [
      SeasonDetailLoading(),
      SeasonDetailHasData(tSeasonDetail),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute(1, 1));
    },
  );

  blocTest<SeasonDetailBloc, SeasonDetailState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockUsecase.execute(1, 1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchSeasonDetail(1, 1)),
    expect: () => [
      SeasonDetailLoading(),
      SeasonDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute(1, 1));
    },
  );
}
