import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/recurring_transaction_repository.dart';

import '../../use_case.dart';

class UpdateRecurringTransactionUseCase extends UseCase {
  UpdateRecurringTransactionUseCase(
      {@required this.recurringTransactionRepository,
      @required this.defaultWalletRepository});

  final RecurringTransactionRepository recurringTransactionRepository;
  final DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> update(
      {@required RecurringTransaction updateRecurringTransaction}) async {
    return recurringTransactionRepository
        .update(updateRecurringTransaction);
  }

  /// Updates to New Amount
  Future<Either<Failure, void>> updateAmount(
      {@required double newAmount, String recurringTransactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        amount: newAmount);
    return update(updateRecurringTransaction: transaction);
  }

  /// Updates the Description
  Future<Either<Failure, void>> updateDescription(
      {@required String description, String recurringTransactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        description: description);
    return update(updateRecurringTransaction: transaction);
  }

  /// Updates the account id
  Future<Either<Failure, void>> updateAccountId(
      {@required String accountId, String recurringTransactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        accountId: accountId);
    return update(updateRecurringTransaction: transaction);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      {@required String categoryId, String recurringTransactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        category: categoryId);
    return update(updateRecurringTransaction: transaction);
  }

  /// Updates the recurrence
  Future<Either<Failure, void>> updateRecurrence(
      {@required Recurrence recurrence, String recurringTransactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        recurrence: recurrence);
    return update(updateRecurringTransaction: transaction);
  }

  /// Updates the tags
  Future<Either<Failure, void>> updateTags(
      {@required List<String> tags, String recurringTransactionId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        tags: tags);
    return update(updateRecurringTransaction: transaction);
  }
}
