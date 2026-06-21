import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetOnTheAirTVs {
  final TVRepository repository;

  GetOnTheAirTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getOnTheAirTVs();
  }
}
