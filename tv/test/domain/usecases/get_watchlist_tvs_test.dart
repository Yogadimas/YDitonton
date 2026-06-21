import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetWatchlistTVs(mockTVRepository);
  });

  final tTVs = <TV>[];

  test('should get list of watchlist tvs from the repository', () async {
    // arrange
    when(
      mockTVRepository.getWatchlistTVs(),
    ).thenAnswer((_) async => Right(tTVs));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVs));
  });
}
