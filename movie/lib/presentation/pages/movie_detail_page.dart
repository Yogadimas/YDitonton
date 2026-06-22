import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final int id;

  const MovieDetailPage({required this.id, super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
      context
          .read<MovieRecommendationsBloc>()
          .add(FetchMovieRecommendations(widget.id));
      context.read<MovieWatchlistBloc>().add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailHasData) {
            return SafeArea(
              child: DetailContent(state.result),
            );
          } else if (state is MovieDetailError) {
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
  final MovieDetail movie;

  const DetailContent(this.movie, {super.key});

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
      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
        backgroundColor: richBlack,
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
              color: richBlack,
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
        Text(movie.title, style: heading5),
        _buildWatchlistButton(context),
        Text(_showGenres(movie.genres)),
        Text(_showDuration(movie.runtime)),
        _buildRatingRow(),
        const SizedBox(height: 16),
        Text('Sinopsis', style: heading6),
        Text(movie.overview),
        const SizedBox(height: 16),
        Text('Rekomendasi', style: heading6),
        _buildRecommendations(),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        RatingBarIndicator(
          rating: movie.voteAverage / 2,
          itemCount: 5,
          itemBuilder: (_, index) =>
              const Icon(Icons.star, color: mikadoYellow),
          itemSize: 24,
        ),
        Text(movie.voteAverage.toStringAsFixed(1)),
      ],
    );
  }

  Widget _buildWatchlistButton(BuildContext context) {
    return BlocConsumer<MovieWatchlistBloc, MovieWatchlistState>(
      listener: (context, state) {
        if (state is MovieWatchlistMessage) {
          final message = state.message;
          if (message == MovieWatchlistBloc.watchlistAddSuccessMessage ||
              message == MovieWatchlistBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(content: Text(message)),
            );
          }
        } else if (state is MovieWatchlistError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        bool isAddedWatchlist = false;
        if (state is MovieWatchlistStatus) {
          isAddedWatchlist = state.isAdded;
        }

        return FilledButton(
          onPressed: () {
            if (!isAddedWatchlist) {
              context
                  .read<MovieWatchlistBloc>()
                  .add(AddMovieToWatchlist(movie));
            } else {
              context
                  .read<MovieWatchlistBloc>()
                  .add(RemoveMovieFromWatchlist(movie));
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

  Widget _buildRecommendations() {
    return BlocBuilder<MovieRecommendationsBloc, MovieRecommendationsState>(
      builder: (context, state) {
        if (state is MovieRecommendationsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieRecommendationsError) {
          return Text(state.message);
        } else if (state is MovieRecommendationsHasData) {
          return _buildRecommendationList(context, state.result);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildRecommendationList(
      BuildContext context, List<Movie> recommendations) {
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
                MovieDetailPage.routeName,
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

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;
    if (hours > 0) return '${hours}j ${minutes}m';
    return '${minutes}m';
  }
}
