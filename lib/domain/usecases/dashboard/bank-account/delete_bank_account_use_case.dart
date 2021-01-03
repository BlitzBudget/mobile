import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

class DeleteBankAccountUseCase {
  BankAccountRepository bankAccountRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> delete({@required String itemId}) async {
    var defaultWallet = await defaultWalletRepository.readDefaultWallet();

    return await bankAccountRepository.delete(defaultWallet, itemId);
  }
}
