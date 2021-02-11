import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

import '../../use_case.dart';

class UpdateTransactionUseCase extends UseCase {
  final TransactionRepository transactionRepository;
  final DefaultWalletRepository defaultWalletRepository;

  UpdateTransactionUseCase(
      {@required this.transactionRepository,
      @required this.defaultWalletRepository});

  Future<Either<Failure, void>> update(
      {@required Transaction updateTransaction}) async {
    return await transactionRepository.update(updateTransaction);
  }

  /// Updates to New Amount
  Future<Either<Failure, void>> updateAmount(
      {@required double newAmount, @required String transactionId}) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, amount: newAmount);
    return await update(updateTransaction: transaction);
  }

  /// Updates the Description
  Future<Either<Failure, void>> updateDescription(
      {@required String description, @required String transactionId}) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        description: description);
    return await update(updateTransaction: transaction);
  }

  /// Updates the account id
  Future<Either<Failure, void>> updateAccountId(
      {@required String accountId, @required String transactionId}) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, accountId: accountId);
    return await update(updateTransaction: transaction);
  }

  /// Updates the date meant for
  Future<Either<Failure, void>> updateDateMeantFor(
      {@required String dateMeantFor, @required String transactionId}) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        dateMeantFor: dateMeantFor);
    return await update(updateTransaction: transaction);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      {@required String categoryId, @required String transactionId}) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        categoryId: categoryId);
    return await update(updateTransaction: transaction);
  }

  /// Updates the recurrence
  Future<Either<Failure, void>> updateRecurrence(
      {@required Recurrence recurrence, @required String transactionId}) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        recurrence: recurrence);
    return await update(updateTransaction: transaction);
  }

  /// Updates the tags
  Future<Either<Failure, void>> updateTags(
      {@required List<String> tags, @required String transactionId}) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, tags: tags);
    return await update(updateTransaction: transaction);
  }
}
