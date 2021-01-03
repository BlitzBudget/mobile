import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';

class UpdateBankAccountUseCase {
  BankAccountRepository bankAccountRepository;

  Future<Either<Failure, void>> update(
      {@required BankAccount updateBankAccount}) async {
    return await bankAccountRepository.update(updateBankAccount);
  }
}
