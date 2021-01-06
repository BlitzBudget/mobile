import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';

abstract class RecurringTransactionRepository {
  Future<Either<Failure, void>> update(
      RecurringTransaction updateRecurringTransaction);
}
