import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TV>>> getOnTheAirTVs();

  Future<Either<Failure, List<TV>>> getPopularTVs();

  Future<Either<Failure, List<TV>>> getTopRatedTVs();

  Future<Either<Failure, TVDetail>> getTVDetail(int id);

  Future<Either<Failure, List<TV>>> getTVRecommendations(int id);

  Future<Either<Failure, List<TV>>> searchTVs(String query);

  Future<Either<Failure, String>> saveWatchlistTV(TVDetail tv);

  Future<Either<Failure, String>> removeWatchlistTV(TVDetail tv);

  Future<bool> isAddedToWatchlistTV(int id);

  Future<Either<Failure, List<TV>>> getWatchlistTVs();

  Future<Either<Failure, SeasonDetail>> getTVSeasonDetail(
      int tvId, int seasonNumber);
}
