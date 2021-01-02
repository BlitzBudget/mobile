import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/ends_with_date_local_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import '../../../constants/constants.dart' as constants;

class EndsWithDateRepositoryImpl implements EndsWithDateRepository {
  final EndsWithDateLocalDataSource endsWithDateLocalDataSource;

  EndsWithDateRepositoryImpl({@required this.endsWithDateLocalDataSource});

  @override
  Future<String> readEndsWithDate() async {
    var endsWithDate = await endsWithDateLocalDataSource.readEndsWithDate();

    // Update shared preferences with Start Date if Empty
    if (isEmpty(endsWithDate)) {
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
    return await endsWithDateLocalDataSource.writeEndsWithDate(value);
  }
}
