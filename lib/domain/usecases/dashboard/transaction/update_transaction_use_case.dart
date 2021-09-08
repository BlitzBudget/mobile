import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

import '../../use_case.dart';

class UpdateTransactionUseCase extends UseCase {
  UpdateTransactionUseCase(
      {required this.transactionRepository,
      required this.defaultWalletRepository});

  final TransactionRepository? transactionRepository;
  final DefaultWalletRepository? defaultWalletRepository;

  Future<Either<Failure, void>> _update(
      {required Transaction updateTransaction}) async {
    return transactionRepository!.update(updateTransaction);
  }

  /// Updates to New Amount
  Future<Either<Failure, void>> updateAmount(
      {required double? newAmount, required String? transactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, amount: newAmount);
    return _update(updateTransaction: transaction);
  }

  /// Updates the Description
  Future<Either<Failure, void>> updateDescription(
      {required String? description, required String? transactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        description: description);
    return _update(updateTransaction: transaction);
  }

  /// Updates the account id
  Future<Either<Failure, void>> updateAccountId(
      {required String? accountId, required String? transactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, accountId: accountId);
    return _update(updateTransaction: transaction);
  }

  /// Updates the date meant for
  Future<Either<Failure, void>> updateDateMeantFor(
      {required String? dateMeantFor, required String? transactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        dateMeantFor: dateMeantFor);
    return _update(updateTransaction: transaction);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      {required String? categoryId, required String? transactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        categoryId: categoryId);
    return _update(updateTransaction: transaction);
  }

  /// Updates the recurrence
  Future<Either<Failure, void>> updateRecurrence(
      {required Recurrence? recurrence, required String? transactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        recurrence: recurrence);
    return _update(updateTransaction: transaction);
  }

  /// Updates the tags
  Future<Either<Failure, void>> updateTags(
      {required List<String>? tags, required String? transactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository!.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, tags: tags);
    return _update(updateTransaction: transaction);
  }
}
