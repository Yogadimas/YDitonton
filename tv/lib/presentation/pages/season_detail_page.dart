import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:tv/presentation/pages/episode_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/season_detail_bloc.dart';

class SeasonDetailArguments {
  final int tvId;
  final int seasonNumber;

  SeasonDetailArguments({required this.tvId, required this.seasonNumber});
}

class SeasonDetailPage extends StatefulWidget {
  static const routeName = '/season-detail';
  final SeasonDetailArguments args;

  const SeasonDetailPage({required this.args, super.key});

  @override
  State<SeasonDetailPage> createState() => _SeasonDetailPageState();
}

class _SeasonDetailPageState extends State<SeasonDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context
          .read<SeasonDetailBloc>()
          .add(FetchSeasonDetail(widget.args.tvId, widget.args.seasonNumber));
    });
  }

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
        title: Text('Season ${widget.args.seasonNumber} Detail'),
      ),
      body: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
        builder: (context, state) {
          if (state is SeasonDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SeasonDetailHasData) {
            final season = state.result;
            final episodes = season.episodes;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(season.name, style: kHeading5),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(_formatDate(season.airDate)),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, color: kMikadoYellow, size: 16),
                      const SizedBox(width: 4),
                      Text(season.voteAverage.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    season.overview.isNotEmpty
                        ? season.overview
                        : 'No overview available.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Text('Episodes', style: kHeading6),
                  const SizedBox(height: 8),
                  Expanded(
                    child: episodes.isEmpty
                        ? const Center(child: Text('No episodes found'))
                        : ListView.builder(
                            itemCount: episodes.length,
                            itemBuilder: (_, index) {
                              final episode = episodes[index];
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      EpisodeDetailPage.routeName,
                                      arguments: episode,
                                    );
                                  },
                                  leading: episode.stillPath != null
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              'https://image.tmdb.org/t/p/w500${episode.stillPath}',
                                          width: 80,
                                          fit: BoxFit.cover,
                                          placeholder: (context, _) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : const SizedBox(
                                          width: 80,
                                          child: Icon(Icons.image),
                                        ),
                                  title: Text(
                                      '${episode.episodeNumber}. ${episode.name}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              size: 12),
                                          const SizedBox(width: 4),
                                          Text(_formatDate(episode.airDate),
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.star,
                                              size: 12, color: kMikadoYellow),
                                          const SizedBox(width: 4),
                                          Text(
                                              episode.voteAverage
                                                  .toStringAsFixed(1),
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        episode.overview.isNotEmpty
                                            ? episode.overview
                                            : 'No synopsis available',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          } else if (state is SeasonDetailError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
