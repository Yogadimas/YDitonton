import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/utils/exception.dart';
import 'package:tv/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertWatchlist(TVTable tv);

  Future<String> removeWatchlist(TVTable tv);

  Future<TVTable?> getTVById(int id);

  Future<List<TVTable>> getWatchlistTVs();
}

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(TVTable tv) async {
    try {
      await databaseHelper.insertWatchlistTV(tv.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TVTable tv) async {
    try {
      await databaseHelper.removeWatchlistTV(tv.toJson());
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVTable?> getTVById(int id) async {
    final result = await databaseHelper.getTVById(id);
    if (result != null) {
      return TVTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTVs() async {
    final result = await databaseHelper.getWatchlistTVs();
    return result.map((data) => TVTable.fromMap(data)).toList();
  }
}
