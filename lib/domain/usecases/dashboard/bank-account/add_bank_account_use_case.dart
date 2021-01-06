import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

class AddBankAccountUseCase {
  BankAccountRepository bankAccountRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> add(
      {@required BankAccount addBankAccount}) async {
    return await bankAccountRepository.add(addBankAccount);
  }
}
