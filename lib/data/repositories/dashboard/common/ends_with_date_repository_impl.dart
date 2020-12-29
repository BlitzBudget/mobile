import '../../datasource/local/authentication/ends_with_date_local_data_source.dart';

class EndsWithDateRepositoryImpl implements EndsWithDateRepository {
  final EndsWithDateLocalDataSource endsWithDateLocalDataSource;

  EndsWithDateRepositoryImpl({@required this.endsWithDateLocalDataSource});

  @override
  Future<String> readEndsWithDate() async {
    return await endsWithDateLocalDataSource.readEndsWithDate();
  }

  Future<void> writeEndsWithDate(String value) async {
    return await endsWithDateLocalDataSource.writeEndsWithDate(value);
  }
}
