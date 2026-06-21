import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = RemoveWatchlistTV(mockTVRepository);
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

  test('should remove watchlist tv from repository', () async {
    // arrange
    when(
      mockTVRepository.removeWatchlistTV(tTVDetail),
    ).thenAnswer((_) async => Right('Removed'));
    // act
    final result = await usecase.execute(tTVDetail);
    // assert
    expect(result, Right('Removed'));
  });
}
