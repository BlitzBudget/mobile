import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

class UpdateTransactionUseCase {
  TransactionRepository transactionRepository;

  Future<Either<Failure, void>> update(
      {@required Transaction updateTransaction}) async {
    return await transactionRepository.update(updateTransaction);
  }
}
