import '../../datasource/local/authentication/starts_with_date_local_data_source.dart';
import '../../../constants/constants.dart' as constants;

class StartsWithDateRepositoryImpl implements StartsWithDateRepository {
  final StartsWithDateLocalDataSource startsWithDateLocalDataSource;

  StartsWithDateRepositoryImpl({@required this.startsWithDateLocalDataSource});

  @override
  Future<String> readStartsWithDate() async {
    String startsWithDate =
        await startsWithDateLocalDataSource.readStartsWithDate();

    // Update shared preferences with Start Date if Empty
    if (isEmpty(startsWithDate)) {
      // Calculate the start date from now
      // Format the calculated date to string
      startsWithDate = DateFormat(constants.dateFormatStartAndEndDate)
          .format(new DateTime.now());

      /// Write starts with date
      await writeStartsWithDate(startsWithDate);
    }

    return startsWithDate;
  }

  Future<void> writeStartsWithDate(String value) async {
    return await startsWithDateLocalDataSource.writeStartsWithDate(value);
  }
}
