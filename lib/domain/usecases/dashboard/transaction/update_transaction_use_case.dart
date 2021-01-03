import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/recurrence.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/transaction/transaction_repository.dart';

class UpdateTransactionUseCase {
  TransactionRepository transactionRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> update(
      {@required Transaction updateTransaction}) async {
    return await transactionRepository.update(updateTransaction);
  }

  /// Updates to New Amount
  Future<Either<Failure, void>> updateAmount(
      double newAmount, String transactionId) async {
    var walletId = await fetchWalletId();
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, amount: newAmount);
    return await update(updateTransaction: transaction);
  }

  /// Updates the Description
  Future<Either<Failure, void>> updateDescription(
      String description, String transactionId) async {
    var walletId = await fetchWalletId();
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        description: description);
    return await update(updateTransaction: transaction);
  }

  /// Updates the account id
  Future<Either<Failure, void>> updateAccountId(
      String accountId, String transactionId) async {
    var walletId = await fetchWalletId();
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, accountId: accountId);
    return await update(updateTransaction: transaction);
  }

  /// Updates the date meant for
  Future<Either<Failure, void>> updateDateMeantFor(
      String dateMeantFor, String transactionId) async {
    var walletId = await fetchWalletId();
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        dateMeantFor: dateMeantFor);
    return await update(updateTransaction: transaction);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      String categoryId, String transactionId) async {
    var walletId = await fetchWalletId();
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, categoryId: categoryId);
    return await update(updateTransaction: transaction);
  }

  /// Updates the recurrence
  Future<Either<Failure, void>> updateRecurrence(
      Recurrence recurrence, String transactionId) async {
    var walletId = await fetchWalletId();
    final transaction = Transaction(
        walletId: walletId,
        transactionId: transactionId,
        recurrence: recurrence);
    return await update(updateTransaction: transaction);
  }

  /// Updates the tags
  Future<Either<Failure, void>> updateTags(
      List<String> tags, String transactionId) async {
    var walletId = await fetchWalletId();
    final transaction = Transaction(
        walletId: walletId, transactionId: transactionId, tags: tags);
    return await update(updateTransaction: transaction);
  }

  // Fetch the user object from the secure storage
  Future<String> fetchWalletId() async {
    return await defaultWalletRepository.readDefaultWallet();
  }
}
