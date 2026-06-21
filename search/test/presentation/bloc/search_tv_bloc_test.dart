import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';
import 'package:search/presentation/bloc/search_tv_event.dart';
import 'package:search/presentation/bloc/search_tv_state.dart';
import 'package:tv/domain/entities/tv.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTVs])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTVs mockSearchTVs;

  setUp(() {
    mockSearchTVs = MockSearchTVs();
    searchTvBloc = SearchTvBloc(mockSearchTVs);
  });

  final tTvModel = TV(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
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
  final tTvList = <TV>[tTvModel];
  final tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(searchTvBloc.state, SearchTvEmpty());
  });

  test('props should be correct', () {
    expect(const OnQueryChangedTv('spiderman').props, ['spiderman']);
    expect(SearchTvEmpty().props, []);
    expect(SearchTvLoading().props, []);
    expect(const SearchTvError('Error').props, ['Error']);
    expect(SearchTvHasData(tTvList).props, [tTvList]);
  });

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTVs.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(OnQueryChangedTv(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvLoading(),
      SearchTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTVs.execute(tQuery));
    },
  );

  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTVs.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(OnQueryChangedTv(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvLoading(),
      SearchTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTVs.execute(tQuery));
    },
  );
}
