import 'dart:ui';

import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/utils/http_ssl_pinning.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:search/search.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/season_detail_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendations_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';
import 'package:tv/presentation/pages/episode_detail_page.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:tv/presentation/pages/season_detail_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import 'firebase_options.dart';
import 'injection.dart' as di;
import 'presentation/pages/watchlist_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<SearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTVsBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTVsBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTVsBloc>()),
        BlocProvider(create: (_) => di.locator<TVDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TVRecommendationsBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVsBloc>()),
        BlocProvider(create: (_) => di.locator<TVWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<SeasonDetailBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTvBloc>()),
      ],
      child: MaterialApp(
        title: 'Y Ditonton',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver, MyApp.observer],
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData.dark().copyWith(
      colorScheme: kColorScheme,
      primaryColor: kRichBlack,
      scaffoldBackgroundColor: kRichBlack,
      textTheme: kTextTheme,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final movieRoute = _movieRoute(settings);
    if (movieRoute != null) return movieRoute;

    final tvRoute = _tvRoute(settings);
    if (tvRoute != null) return tvRoute;

    return _fallbackRoute(settings);
  }

  Route<dynamic>? _movieRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeMoviePage());
      case PopularMoviesPage.routeName:
        return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
      case TopRatedMoviesPage.routeName:
        return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
      case MovieDetailPage.routeName:
        final id = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MovieDetailPage(id: id),
          settings: settings,
        );
      case searchRoute:
        return CupertinoPageRoute(builder: (_) => SearchPage());
      default:
        return null;
    }
  }

  Route<dynamic>? _tvRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeTVPage.routeName:
        return MaterialPageRoute(builder: (_) => HomeTVPage());
      case OnTheAirTVsPage.routeName:
        return CupertinoPageRoute(builder: (_) => OnTheAirTVsPage());
      case PopularTVsPage.routeName:
        return CupertinoPageRoute(builder: (_) => PopularTVsPage());
      case TopRatedTVsPage.routeName:
        return CupertinoPageRoute(builder: (_) => TopRatedTVsPage());
      case TVDetailPage.routeName:
        final tvId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TVDetailPage(id: tvId),
          settings: settings,
        );
      case SeasonDetailPage.routeName:
        final args = settings.arguments as SeasonDetailArguments;
        return MaterialPageRoute(
          builder: (_) => SeasonDetailPage(args: args),
          settings: settings,
        );
      case EpisodeDetailPage.routeName:
        final episode = settings.arguments as Episode;
        return MaterialPageRoute(
          builder: (_) => EpisodeDetailPage(episode: episode),
          settings: settings,
        );
      case searchTvRoute:
        return CupertinoPageRoute(builder: (_) => SearchTVPage());
      case WatchlistPage.routeName:
        return MaterialPageRoute(builder: (_) => WatchlistPage());
      case aboutRoute:
        return MaterialPageRoute(builder: (_) => AboutPage());
      default:
        return null;
    }
  }

  Route<dynamic> _fallbackRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('Halaman tidak ditemukan: ${settings.name}')),
      ),
    );
  }
}
