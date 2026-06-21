import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:tv/domain/entities/tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SearchTVs(mockTVRepository);
  });

  final tTVs = <TV>[];
  final tQuery = 'spiderman';

  test('should get list of tvs from the repository', () async {
    // arrange
    when(
      mockTVRepository.searchTVs(tQuery),
    ).thenAnswer((_) async => Right(tTVs));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTVs));
  });
}
