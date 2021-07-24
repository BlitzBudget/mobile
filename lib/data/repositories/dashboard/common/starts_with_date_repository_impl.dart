import 'package:intl/intl.dart';
import 'package:mobile_blitzbudget/data/datasource/local/dashboard/starts_with_date_local_data_source.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';

import '../../../constants/constants.dart' as constants;

class StartsWithDateRepositoryImpl implements StartsWithDateRepository {
  StartsWithDateRepositoryImpl({required this.startsWithDateLocalDataSource});

  late final StartsWithDateLocalDataSource startsWithDateLocalDataSource;

  @override
  Future<String> readStartsWithDate() async {
    String startsWithDate;
    try {
      startsWithDate = await startsWithDateLocalDataSource.readStartsWithDate();
    } on Exception {
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
    return startsWithDateLocalDataSource!.writeStartsWithDate(value);
  }
}
