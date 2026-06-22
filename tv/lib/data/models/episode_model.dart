import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/episode.dart';

class EpisodeModel extends Equatable {
  const EpisodeModel({
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

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        seasonNumber: json['season_number'],
        episodeNumber: json['episode_number'],
        stillPath: json['still_path'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count'],
        airDate: json['air_date'],
        crew: json['crew'] != null
            ? List<String>.from(
                (json['crew'] as List).map((x) => '${x['name']} (${x['job']})'))
            : [],
        guestStars: json['guest_stars'] != null
            ? List<String>.from((json['guest_stars'] as List)
                .map((x) => '${x['name']} as ${x['character']}'))
            : [],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'season_number': seasonNumber,
      'episode_number': episodeNumber,
      'still_path': stillPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'air_date': airDate,
    };
  }

  Episode toEntity() {
    return Episode(
      id: id,
      name: name,
      overview: overview,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      stillPath: stillPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      airDate: airDate,
      crew: crew,
      guestStars: guestStars,
    );
  }

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
