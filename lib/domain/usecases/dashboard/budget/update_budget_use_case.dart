import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';

class UpdateBudgetUseCase {
  BudgetRepository budgetRepository;
  DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> update({@required Budget updateBudget}) async {
    return await budgetRepository.update(updateBudget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updatePlanned(
      String categoryId, String budgetId) async {
    var walletId = await fetchWalletId();
    final budget =
        Budget(walletId: walletId, budgetId: budgetId, categoryId: categoryId);
    return await update(updateBudget: budget);
  }

  /// Updates the date meant for
  Future<Either<Failure, void>> updateDateMeantFor(
      String dateMeantFor, String budgetId) async {
    var walletId = await fetchWalletId();
    final budget = Budget(
        walletId: walletId, budgetId: budgetId, dateMeantFor: dateMeantFor);
    return await update(updateBudget: budget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      String categoryId, String budgetId) async {
    var walletId = await fetchWalletId();
    final budget =
        Budget(walletId: walletId, budgetId: budgetId, categoryId: categoryId);
    return await update(updateBudget: budget);
  }

  // Fetch the user object from the secure storage
  Future<String> fetchWalletId() async {
    return await defaultWalletRepository.readDefaultWallet();
  }
}
