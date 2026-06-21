import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const routeName = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistMoviesBloc>().add(FetchWatchlistMovies());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMoviesBloc>().add(FetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
        builder: (context, state) {
          if (state is WatchlistMoviesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WatchlistMoviesHasData) {
            if (state.result.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada film di Watchlist Anda',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (_, index) {
                final movie = state.result[index];
                return MovieCard(movie);
              },
              itemCount: state.result.length,
            );
          } else if (state is WatchlistMoviesError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
