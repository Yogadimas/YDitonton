import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendations_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist_bloc.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';

class TVDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv';

  final int id;

  const TVDetailPage({required this.id, super.key});

  @override
  State<TVDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVDetailBloc>().add(FetchTVDetail(widget.id));
      context
          .read<TVRecommendationsBloc>()
          .add(FetchTVRecommendations(widget.id));
      context.read<TVWatchlistBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVDetailBloc, TVDetailState>(
        builder: (context, state) {
          if (state is TVDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TVDetailHasData) {
            return SafeArea(
              child: DetailContent(state.result),
            );
          } else if (state is TVDetailError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TVDetail tv;

  const DetailContent(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        _buildPosterImage(screenWidth),
        _buildScrollableSheet(context),
        _buildBackButton(context),
      ],
    );
  }

  Widget _buildPosterImage(double screenWidth) {
    return CachedNetworkImage(
      imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
      width: screenWidth,
      placeholder: (context, _) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: kRichBlack,
        foregroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildScrollableSheet(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 48 + 8),
      child: DraggableScrollableSheet(
        minChildSize: 0.25,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: kRichBlack,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Stack(
              children: [
                _buildDragHandle(),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: _buildDetailBody(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(color: Colors.white, height: 4, width: 48),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tv.name, style: kHeading5),
        _buildWatchlistButton(context),
        Text(_showGenres(tv.genres)),
        _buildRatingRow(),
        const SizedBox(height: 16),
        Text('Sinopsis', style: kHeading6),
        Text(tv.overview),
        const SizedBox(height: 16),
        Text('Musim', style: kHeading6),
        _buildSeasonList(),
        const SizedBox(height: 16),
        Text('Rekomendasi', style: kHeading6),
        _buildRecommendations(),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        RatingBarIndicator(
          rating: tv.voteAverage / 2,
          itemCount: 5,
          itemBuilder: (_, index) =>
              const Icon(Icons.star, color: kMikadoYellow),
          itemSize: 24,
        ),
        Text(tv.voteAverage.toStringAsFixed(1)),
      ],
    );
  }

  Widget _buildWatchlistButton(BuildContext context) {
    return BlocConsumer<TVWatchlistBloc, TVWatchlistState>(
      listener: (context, state) {
        if (state is TVWatchlistMessage) {
          final message = state.message;
          if (message == TVWatchlistBloc.watchlistAddSuccessMessage ||
              message == TVWatchlistBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(content: Text(message)),
            );
          }
        } else if (state is TVWatchlistError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        bool isAddedWatchlist = false;
        if (state is TVWatchlistStatus) {
          isAddedWatchlist = state.isAdded;
        }

        return ElevatedButton(
          onPressed: () {
            if (!isAddedWatchlist) {
              context.read<TVWatchlistBloc>().add(AddTVToWatchlist(tv));
            } else {
              context.read<TVWatchlistBloc>().add(RemoveTVFromWatchlist(tv));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isAddedWatchlist
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
              const Text('Watchlist'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeasonList() {
    if (tv.seasons.isEmpty) return const Text('Belum ada data musim');
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tv.seasons.length,
        itemBuilder: (context, index) =>
            _buildSeasonItem(context, tv.seasons[index]),
      ),
    );
  }

  Widget _buildSeasonItem(BuildContext context, Season season) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          SeasonDetailPage.routeName,
          arguments: SeasonDetailArguments(
            tvId: tv.id,
            seasonNumber: season.seasonNumber,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            season.posterPath != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${season.posterPath}',
                      height: 100,
                      placeholder: (context, _) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : Container(
                    height: 100,
                    width: 70,
                    color: Colors.grey,
                    child: const Icon(Icons.image),
                  ),
            const SizedBox(height: 4),
            Text('Musim ${season.seasonNumber}'),
            Text(
              '${season.episodeCount} eps',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return BlocBuilder<TVRecommendationsBloc, TVRecommendationsState>(
      builder: (context, state) {
        if (state is TVRecommendationsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TVRecommendationsError) {
          return Text(state.message);
        } else if (state is TVRecommendationsHasData) {
          return _buildRecommendationList(context, state.result);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRecommendationList(
      BuildContext context, List<TV> recommendations) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendations.length,
        itemBuilder: (_, index) {
          final item = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () => Navigator.pushReplacementNamed(
                context,
                TVDetailPage.routeName,
                arguments: item.id,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: 'https://image.tmdb.org/t/p/w500${item.posterPath}',
                  placeholder: (context, _) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    if (genres.isEmpty) return '';
    return genres.map((g) => g.name).join(', ');
  }
}
