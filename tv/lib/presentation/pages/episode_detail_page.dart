import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tv/domain/entities/episode.dart';

class EpisodeDetailPage extends StatelessWidget {
  static const routeName = '/detail-episode';
  final Episode episode;

  const EpisodeDetailPage({required this.episode, super.key});

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            episode.stillPath != null
                ? CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${episode.stillPath}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.image, size: 50),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Episode ${episode.episodeNumber}: ${episode.name}',
                    style: kHeading5,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(_formatDate(episode.airDate)),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, color: kMikadoYellow, size: 16),
                      const SizedBox(width: 4),
                      Text(
                          '${episode.voteAverage} (${episode.voteCount} votes)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Overview', style: kHeading6),
                  const SizedBox(height: 8),
                  Text(
                    episode.overview.isNotEmpty
                        ? episode.overview
                        : 'No synopsis available.',
                  ),
                  const SizedBox(height: 16),
                  if (episode.crew.isNotEmpty) ...[
                    Text('Crew', style: kHeading6),
                    const SizedBox(height: 8),
                    Text(episode.crew.join(', ')),
                    const SizedBox(height: 16),
                  ],
                  if (episode.guestStars.isNotEmpty) ...[
                    Text('Guest Stars', style: kHeading6),
                    const SizedBox(height: 8),
                    Text(episode.guestStars.join(', ')),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
