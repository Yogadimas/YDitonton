import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeasonDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVSeasonDetail(mockTVRepository);
  });

  const tId = 1;
  const tSeasonNumber = 1;
  const tEpisode = Episode(
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    episodeNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 1.0,
    voteCount: 1,
    airDate: '2021-01-01',
    crew: [],
    guestStars: [],
  );

  final tSeasonDetail = SeasonDetail(
    id: 1,
    airDate: '2021-01-01',
    episodes: [tEpisode],
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
    voteAverage: 1.0,
  );

  test('should get season detail from the repository', () async {
    // arrange
    when(mockTVRepository.getTVSeasonDetail(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(tSeasonDetail));
    // act
    final result = await usecase.execute(tId, tSeasonNumber);
    // assert
    expect(result, Right(tSeasonDetail));
  });
}
