import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

import '../../use_case.dart';

class UpdateBankAccountUseCase extends UseCase {
  UpdateBankAccountUseCase(
      {required this.bankAccountRepository,
      required this.defaultWalletRepository});

  final BankAccountRepository? bankAccountRepository;
  final DefaultWalletRepository? defaultWalletRepository;

  Future<Either<Failure, void>> update(
      {required BankAccount updateBankAccount}) async {
    return bankAccountRepository!.update(updateBankAccount);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateBankAccountName(
      {required String? bankAccountName, required String? accountId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final budget = BankAccount(
        walletId: walletId,
        accountId: accountId,
        bankAccountName: bankAccountName);
    return update(updateBankAccount: budget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateSelectedAccount(
      {required bool? selectedAccount, required String? accountId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final budget = BankAccount(
        walletId: walletId,
        accountId: accountId,
        selectedAccount: selectedAccount);
    return update(updateBankAccount: budget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateAccountBalance(
      {required double? accountBalance, required String? accountId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final budget = BankAccount(
        walletId: walletId,
        accountId: accountId,
        accountBalance: accountBalance);
    return update(updateBankAccount: budget);
  }
}
