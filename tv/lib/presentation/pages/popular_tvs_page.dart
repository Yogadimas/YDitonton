import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class PopularTVsPage extends StatefulWidget {
  static const routeName = '/popular-tv';

  const PopularTVsPage({super.key});

  @override
  State<PopularTVsPage> createState() => _PopularTVsPageState();
}

class _PopularTVsPageState extends State<PopularTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<PopularTVsBloc>().add(FetchPopularTVs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVsBloc, PopularTVsState>(
          builder: (context, state) {
            if (state is PopularTVsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PopularTVsHasData) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final tv = state.result[index];
                  return TVCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is PopularTVsError) {
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
