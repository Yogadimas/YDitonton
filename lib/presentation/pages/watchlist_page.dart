import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';

class WatchlistPage extends StatelessWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Movies', icon: Icon(Icons.movie)),
              Tab(text: 'TV Series', icon: Icon(Icons.tv)),
            ],
          ),
        ),
        body: TabBarView(children: [WatchlistMoviesPage(), WatchlistTVsPage()]),
      ),
    );
  }
}
