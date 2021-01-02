import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';

abstract class RecurringTransactionRepository {
  Future<Either<Failure, void>> update(
      RecurringTransactionModel updateRecurringTransaction);
}
