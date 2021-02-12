import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/bank_account_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

import '../../use_case.dart';

class DeleteBankAccountUseCase extends UseCase {
  DeleteBankAccountUseCase(
      {@required this.bankAccountRepository,
      @required this.defaultWalletRepository});

  final BankAccountRepository bankAccountRepository;
  final DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> delete({@required String itemId}) async {
    final defaultWallet = await defaultWalletRepository.readDefaultWallet();

    if (defaultWallet.isLeft()) {
      return Left(EmptyResponseFailure());
    }

    return bankAccountRepository.delete(
        walletId: defaultWallet.getOrElse(null), account: itemId);
  }
}
