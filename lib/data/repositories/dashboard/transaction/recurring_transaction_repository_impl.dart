import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/transaction/recurring_transaction_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/recurring_transaction_repository.dart';

class RecurringTransactionRepositoryImpl
    implements RecurringTransactionRepository {
  RecurringTransactionRepositoryImpl(
      {required this.recurringTransactionRemoteDataSource});

  final RecurringTransactionRemoteDataSource?
      recurringTransactionRemoteDataSource;

  @override
  Future<Either<Failure, void>> update(
      RecurringTransaction updateRecurringTransaction) async {
    try {
      return Right(await recurringTransactionRemoteDataSource!
          .update(updateRecurringTransaction as RecurringTransactionModel));
    } on Exception catch (e) {
      return Left(APIException.convertExceptionToFailure(e));
    }
  }
}
