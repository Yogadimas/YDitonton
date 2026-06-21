import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTVDetail])
void main() {
  late TVDetailBloc bloc;
  late MockGetTVDetail mockUsecase;

  setUp(() {
    mockUsecase = MockGetTVDetail();
    bloc = TVDetailBloc(mockUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, TVDetailEmpty());
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

  blocTest<TVDetailBloc, TVDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute(1)).thenAnswer((_) async => Right(tTVDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTVDetail(1)),
    expect: () => [
      TVDetailLoading(),
      TVDetailHasData(tTVDetail),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute(1));
    },
  );

  blocTest<TVDetailBloc, TVDetailState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockUsecase.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTVDetail(1)),
    expect: () => [
      TVDetailLoading(),
      TVDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockUsecase.execute(1));
    },
  );
}
