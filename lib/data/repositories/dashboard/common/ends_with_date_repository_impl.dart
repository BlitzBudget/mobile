import '../../datasource/local/authentication/ends_with_date_local_data_source.dart';
import '../../../constants/constants.dart' as constants;

class EndsWithDateRepositoryImpl implements EndsWithDateRepository {
  final EndsWithDateLocalDataSource endsWithDateLocalDataSource;

  EndsWithDateRepositoryImpl({@required this.endsWithDateLocalDataSource});

  @override
  Future<String> readEndsWithDate() async {
    String endsWithDate = await endsWithDateLocalDataSource.readEndsWithDate();

    // Update shared preferences with Start Date if Empty
    if (isEmpty(endsWithDate)) {
      // Caculate the end date from now
      final DateTime _nowDate = new DateTime.now();
      // Format the calculated date to string
      endsWithDate = DateFormat(constants.dateFormatStartAndEndDate).format(
          new DateTime(_nowDate.year, _nowDate.month + 1, _nowDate.day));

      /// Write Ends with date
      await writeEndsWithDate(endsWithDate);
    }

    return endsWithDate;
  }

  Future<void> writeEndsWithDate(String value) async {
    return await endsWithDateLocalDataSource.writeEndsWithDate(value);
  }
}
