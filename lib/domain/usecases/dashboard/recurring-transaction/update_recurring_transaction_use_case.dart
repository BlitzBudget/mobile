import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic-failure.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/ends_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/starts_with_date_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/recurring_transaction_repository.dart';

class UpdateRecurringTransactionUseCase {
  RecurringTransactionRepository recurringTransactionRepository;
  StartsWithDateRepository startsWithDateRepository;
  EndsWithDateRepository endsWithDateRepository;
  DefaultWalletRepository defaultWalletRepository;
  UserAttributesRepository userAttributesRepository;

  Future<Either<Failure, void>> update(
      {@required RecurringTransaction updateRecurringTransaction}) async {
    return await recurringTransactionRepository
        .update(updateRecurringTransaction);
  }

  /// Updates to New Amount
  Future<Either<Failure, void>> updateAmount(
      double newAmount, String recurringTransactionId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        amount: newAmount);
    return await update(updateRecurringTransaction: transaction);
  }

  /// Updates the Description
  Future<Either<Failure, void>> updateDescription(
      String description, String recurringTransactionId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        description: description);
    return await update(updateRecurringTransaction: transaction);
  }

  /// Updates the account id
  Future<Either<Failure, void>> updateAccountId(
      String accountId, String recurringTransactionId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        account: accountId);
    return await update(updateRecurringTransaction: transaction);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      String categoryId, String recurringTransactionId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        category: categoryId);
    return await update(updateRecurringTransaction: transaction);
  }

  /// Updates the recurrence
  Future<Either<Failure, void>> updateRecurrence(
      Recurrence recurrence, String recurringTransactionId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        recurrence: recurrence);
    return await update(updateRecurringTransaction: transaction);
  }

  /// Updates the tags
  Future<Either<Failure, void>> updateTags(
      List<String> tags, String recurringTransactionId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final transaction = RecurringTransaction(
        walletId: walletId,
        recurringTransactionId: recurringTransactionId,
        tags: tags);
    return await update(updateRecurringTransaction: transaction);
  }
}
