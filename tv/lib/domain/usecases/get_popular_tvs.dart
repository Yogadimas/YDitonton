import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetPopularTVs {
  final TVRepository repository;

  GetPopularTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getPopularTVs();
  }
}
