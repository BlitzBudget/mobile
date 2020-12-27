import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart' as constants;
import '../../../utils/utils.dart';

/// Fetch Starts With Date from Shared preferences
Future<String> fetchStartsWithDate(SharedPreferences _prefs) async {
  String _startsWithDate = _prefs.getString(constants.startsWithDate);

   // Update shared preferences with Start Date if Empty
    if(isEmpty(_startsWithDate)) {
        // Calculate the start date from now
        final DateTime _nowDate = new DateTime.now();
        // Format the calculated date to string
        _startsWithDate = DateFormat(constants.dateFormatStartAndEndDate).format(_nowDate);
        await _prefs.setString(constants.startsWithDate, _startsWithDate);
    }

    return _startsWithDate;
}

/// Fetch Starts With Date from Shared preferences
Future<String> fetchEndsWithDate(SharedPreferences _prefs) async {
   String _endsWithDate = _prefs.getString(constants.endsWithDate);

   // Update shared preferences with Start Date if Empty
    if(isEmpty(_endsWithDate)) {
        // Caculate the end date from now
        final DateTime _nowDate = new DateTime.now();
        final DateTime _endDate =
        new DateTime(_nowDate.year, _nowDate.month + 1, _nowDate.day);
        // Format the calculated date to string
        _endsWithDate = DateFormat(constants.dateFormatStartAndEndDate).format(_endDate);
        await _prefs.setString(constants.endsWithDate, _endsWithDate);
    }

    return _endsWithDate;
}
