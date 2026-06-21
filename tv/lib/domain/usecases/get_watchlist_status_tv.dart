import 'package:tv/domain/repositories/tv_repository.dart';

class GetWatchlistStatusTV {
  final TVRepository repository;

  GetWatchlistStatusTV(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTV(id);
  }
}
