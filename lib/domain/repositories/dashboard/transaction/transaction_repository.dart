import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> update(TransactionModel updateTransaction);
  Future<Either<Failure, void>> add(TransactionModel addTransaction);
}
