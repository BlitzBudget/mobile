import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';

class DateModel extends Date {
  DateModel(
      {final String walletId,
      final String dateId,
      final double incomeTotal,
      final double expenseTotal,
      final double balance})
      : super(
            walletId: walletId,
            dateId: dateId,
            incomeTotal: incomeTotal,
            expenseTotal: expenseTotal,
            balance: balance);

  /// Map JSON transactions to List of object
  factory DateModel.fromJSON(Map<String, dynamic> transaction) {
    return DateModel(
      walletId: parseDynamicAsString(transaction['walletId']),
      dateId: parseDynamicAsString(transaction['dateId']),
      incomeTotal: parseDynamicAsDouble(transaction['income_total']),
      expenseTotal: parseDynamicAsDouble(transaction['expense_total']),
      balance: parseDynamicAsDouble(transaction['balance']),
    );
  }
}
