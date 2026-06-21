import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/episode.dart';

class SeasonDetail extends Equatable {
  const SeasonDetail({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  final int id;
  final String? airDate;
  final List<Episode> episodes;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        posterPath,
        seasonNumber,
        voteAverage,
      ];
}
