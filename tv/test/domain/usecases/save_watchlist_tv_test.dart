import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SaveWatchlistTV(mockTVRepository);
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

  test('should save watchlist tv to the repository', () async {
    // arrange
    when(
      mockTVRepository.saveWatchlistTV(tTVDetail),
    ).thenAnswer((_) async => Right('Saved'));
    // act
    final result = await usecase.execute(tTVDetail);
    // assert
    expect(result, Right('Saved'));
  });
}
