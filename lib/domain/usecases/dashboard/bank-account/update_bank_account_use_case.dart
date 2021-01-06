import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

class UpdateBankAccountUseCase {
  BankAccountRepository bankAccountRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> update(
      {@required BankAccount updateBankAccount}) async {
    return await bankAccountRepository.update(updateBankAccount);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateBankAccountName(
      String bankAccountName, String accountId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final budget = BankAccount(
        walletId: walletId,
        accountId: accountId,
        bankAccountName: bankAccountName);
    return await update(updateBankAccount: budget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateSelectedAccount(
      bool selectedAccount, String accountId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final budget = BankAccount(
        walletId: walletId,
        accountId: accountId,
        selectedAccount: selectedAccount);
    return await update(updateBankAccount: budget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateAccountBalance(
      double accountBalance, String accountId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final budget = BankAccount(
        walletId: walletId,
        accountId: accountId,
        accountBalance: accountBalance);
    return await update(updateBankAccount: budget);
  }
}
