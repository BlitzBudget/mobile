import '../../datasource/local/authentication/starts_with_date_local_data_source.dart';

class StartsWithDateRepositoryImpl implements StartsWithDateRepository {
  final StartsWithDateLocalDataSource startsWithDateLocalDataSource;

  StartsWithDateRepositoryImpl({@required this.startsWithDateLocalDataSource});

  @override
  Future<String> readStartsWithDate() async {
    return await startsWithDateLocalDataSource.readStartsWithDate();
  }

  Future<void> writeStartsWithDate(String value) async {
    return await startsWithDateLocalDataSource.writeStartsWithDate(value);
  }
}
