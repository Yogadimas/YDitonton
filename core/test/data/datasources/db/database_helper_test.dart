import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final path = await getDatabasesPath();
    await databaseFactory.setDatabasesPath('$path/db_test');
  });

  setUp(() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';
    await databaseFactory.deleteDatabase(databasePath);
  });

  tearDownAll(() async {
    await DatabaseHelper().closeDatabase();
  });

  test(
      'DatabaseHelper should initialize db and trigger onCreate and execute all methods',
      () async {
    final helper = DatabaseHelper();

    final movieData = {
      'id': 1,
      'title': 'Test Movie',
      'overview': 'Test Overview',
      'posterPath': '/path.jpg',
    };

    final tvData = {
      'id': 1,
      'name': 'Test TV',
      'overview': 'Test Overview',
      'posterPath': '/path.jpg',
    };

    // Insert Movie
    final insertMovieResult = await helper.insertWatchlist(movieData);
    expect(insertMovieResult, 1);

    // Get Movie
    final getMovieResult = await helper.getMovieById(1);
    expect(getMovieResult?['id'], 1);

    // Get Watchlist Movies
    final getWatchlistMoviesResult = await helper.getWatchlistMovies();
    expect(getWatchlistMoviesResult.length, 1);

    // Remove Movie
    final removeMovieResult = await helper.removeWatchlist(movieData);
    expect(removeMovieResult, 1);

    // Insert TV
    final insertTVResult = await helper.insertWatchlistTV(tvData);
    expect(insertTVResult, 1);

    // Get TV
    final getTVResult = await helper.getTVById(1);
    expect(getTVResult?['id'], 1);

    // Get Watchlist TVs
    final getWatchlistTVsResult = await helper.getWatchlistTVs();
    expect(getWatchlistTVsResult.length, 1);

    // Remove TV
    final removeTVResult = await helper.removeWatchlistTV(tvData);
    expect(removeTVResult, 1);
  });
}
