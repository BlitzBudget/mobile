import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

import '../../use_case.dart';

class AddTransactionUseCase extends UseCase {
  AddTransactionUseCase(
      {required this.transactionRepository,
      required this.defaultWalletRepository});

  final TransactionRepository? transactionRepository;
  final DefaultWalletRepository? defaultWalletRepository;

  Future<Either<Failure, void>> add(
      {required Transaction addTransaction}) async {
    final defaultWallet = await defaultWalletRepository!.readDefaultWallet();
    if (defaultWallet.isLeft()) {
      return Left(EmptyWalletFailure());
    }

    final walletAsString = defaultWallet.getOrElse(() => '');
    final addTransactionWithWallet = Transaction(
      walletId: walletAsString,
      amount: addTransaction.amount,
      categoryId: addTransaction.categoryId,
      description: addTransaction.description,
      tags: addTransaction.tags,
    );
    return transactionRepository!.add(addTransactionWithWallet);
  }
}
