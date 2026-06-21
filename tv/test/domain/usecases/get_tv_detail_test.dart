import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVDetail(mockTVRepository);
  });

  final tId = 1;
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

  test('should get tv detail from the repository', () async {
    // arrange
    when(
      mockTVRepository.getTVDetail(tId),
    ).thenAnswer((_) async => Right(tTVDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTVDetail));
  });
}
