import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  const Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.crew,
    required this.guestStars,
  });

  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final int episodeNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;
  final String? airDate;
  final List<String> crew;
  final List<String> guestStars;

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        seasonNumber,
        episodeNumber,
        stillPath,
        voteAverage,
        voteCount,
        airDate,
        crew,
        guestStars,
      ];
}
