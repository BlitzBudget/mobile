import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/starts_with_date_local_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';

import 'package:mobile_blitzbudget/core/utils/utils.dart';
import '../../../constants/constants.dart' as constants;

class StartsWithDateRepositoryImpl implements StartsWithDateRepository {
  final StartsWithDateLocalDataSource startsWithDateLocalDataSource;

  StartsWithDateRepositoryImpl({@required this.startsWithDateLocalDataSource});

  @override
  Future<String> readStartsWithDate() async {
    var startsWithDate =
        await startsWithDateLocalDataSource.readStartsWithDate();

    // Update shared preferences with Start Date if Empty
    if (isEmpty(startsWithDate)) {
      // Calculate the start date from now
      // Format the calculated date to string
      startsWithDate = DateFormat(constants.dateFormatStartAndEndDate)
          .format(DateTime.now());

      /// Write starts with date
      await writeStartsWithDate(startsWithDate);
    }

    return startsWithDate;
  }

  @override
  Future<void> writeStartsWithDate(String value) async {
    return await startsWithDateLocalDataSource.writeStartsWithDate(value);
  }
}
