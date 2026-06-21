import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
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

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(tMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailHasData(tMovieDetail),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tId));
    },
  );
}
