import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistStatusTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetWatchlistStatusTV(mockTVRepository);
  });

  final tId = 1;

  test('should get watchlist status from the repository', () async {
    // arrange
    when(
      mockTVRepository.isAddedToWatchlistTV(tId),
    ).thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, true);
  });
}
