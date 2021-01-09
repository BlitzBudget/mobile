import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

import '../../use_case.dart';

class AddTransactionUseCase extends UseCase {
  final TransactionRepository transactionRepository;

  AddTransactionUseCase({@required this.transactionRepository});

  Future<Either<Failure, void>> add(
      {@required Transaction addTransaction}) async {
    return await transactionRepository.add(addTransaction);
  }
}
