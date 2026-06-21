import 'package:mockito/annotations.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

@GenerateMocks([MovieRepository, TVRepository])
void main() {}
