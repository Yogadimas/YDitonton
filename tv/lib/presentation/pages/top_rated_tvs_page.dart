import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class TopRatedTVsPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';

  const TopRatedTVsPage({super.key});

  @override
  State<TopRatedTVsPage> createState() => _TopRatedTVsPageState();
}

class _TopRatedTVsPageState extends State<TopRatedTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TopRatedTVsBloc>().add(FetchTopRatedTVs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVsBloc, TopRatedTVsState>(
          builder: (context, state) {
            if (state is TopRatedTVsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTVsHasData) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final tv = state.result[index];
                  return TVCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedTVsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
