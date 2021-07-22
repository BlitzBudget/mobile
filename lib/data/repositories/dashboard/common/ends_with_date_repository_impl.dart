import 'package:intl/intl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/ends_with_date_local_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import '../../../constants/constants.dart' as constants;

class EndsWithDateRepositoryImpl implements EndsWithDateRepository {
  EndsWithDateRepositoryImpl({required this.endsWithDateLocalDataSource});

  final EndsWithDateLocalDataSource? endsWithDateLocalDataSource;

  @override
  Future<String> readEndsWithDate() async {
    String endsWithDate;
    try {
      endsWithDate = await endsWithDateLocalDataSource!.readEndsWithDate();
    } on Exception {
      // Caculate the end date from now
      final _nowDate = DateTime.now();
      // Format the calculated date to string
      endsWithDate = DateFormat(constants.dateFormatStartAndEndDate)
          .format(DateTime(_nowDate.year, _nowDate.month + 1, _nowDate.day));

      /// Write Ends with date
      await writeEndsWithDate(endsWithDate);
    }

    return endsWithDate;
  }

  @override
  Future<void> writeEndsWithDate(String value) async {
    return endsWithDateLocalDataSource!.writeEndsWithDate(value);
  }
}
