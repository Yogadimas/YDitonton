import 'package:tv/data/models/episode_model.dart';
import 'package:tv/data/models/season_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

final tTVModel = TVModel(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalName: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  firstAirDate: '2002-05-01',
  name: 'Spider-Man',
  voteAverage: 7.2,
  voteCount: 13507,
);

final tTV = TV(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalName: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  firstAirDate: '2002-05-01',
  name: 'Spider-Man',
  voteAverage: 7.2,
  voteCount: 13507,
);

final tTVModelList = <TVModel>[tTVModel];
final tTVList = <TV>[tTV];

final tTVDetail = TVDetail(
  backdropPath: 'backdropPath',
  genres: [],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1.0,
  voteCount: 1,
  seasons: [],
);

final tTVTable = TVTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final tWatchlistTV = TV.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);
final testTVMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

final tEpisodeModel = EpisodeModel(
  id: 1,
  name: 'name',
  overview: 'overview',
  seasonNumber: 1,
  episodeNumber: 1,
  stillPath: 'stillPath',
  voteAverage: 1.0,
  voteCount: 1,
  airDate: '2021-01-01',
  crew: const [],
  guestStars: const [],
);

final tSeasonDetailModel = SeasonDetailModel(
  id: 1,
  airDate: '2021-01-01',
  episodes: [tEpisodeModel],
  name: 'name',
  overview: 'overview',
  posterPath: 'posterPath',
  seasonNumber: 1,
  voteAverage: 1.0,
);

final tEpisode = Episode(
  id: 1,
  name: 'name',
  overview: 'overview',
  seasonNumber: 1,
  episodeNumber: 1,
  stillPath: 'stillPath',
  voteAverage: 1.0,
  voteCount: 1,
  airDate: '2021-01-01',
  crew: const [],
  guestStars: const [],
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
