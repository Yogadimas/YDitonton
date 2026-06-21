import 'package:core/data/datasources/db/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

@GenerateMocks(
  [
    TVRepository,
    TVRemoteDataSource,
    TVLocalDataSource,
    DatabaseHelper,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
