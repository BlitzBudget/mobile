import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> update(Transaction updateTransaction);
  Future<Either<Failure, void>> add(Transaction addTransaction);
  Future<Either<Failure, TransactionResponse>> fetch(String startsWithDate,
      String endsWithDate, String defaultWallet, String userId);
}
