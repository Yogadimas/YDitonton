import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class WatchlistTVsPage extends StatefulWidget {
  const WatchlistTVsPage({super.key});

  @override
  State<WatchlistTVsPage> createState() => _WatchlistTVsPageState();
}

class _WatchlistTVsPageState extends State<WatchlistTVsPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistTVsBloc>().add(FetchWatchlistTVs());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVsBloc>().add(FetchWatchlistTVs());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTVsBloc, WatchlistTVsState>(
        builder: (context, state) {
          if (state is WatchlistTVsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WatchlistTVsHasData) {
            if (state.result.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada TV Series di Watchlist Anda',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (_, index) {
                final tv = state.result[index];
                return TVCard(tv);
              },
              itemCount: state.result.length,
            );
          } else if (state is WatchlistTVsError) {
            return Center(
                key: Key('error_message'), child: Text(state.message));
          } else {
            return Container();
          }
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
