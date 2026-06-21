import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
          builder: (context, state) {
            if (state is TopRatedMoviesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopRatedMoviesHasData) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedMoviesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
