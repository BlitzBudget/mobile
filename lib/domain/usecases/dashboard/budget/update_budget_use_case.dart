import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class UpdateBudgetUseCase extends UseCase {
  final BudgetRepository budgetRepository;
  final DefaultWalletRepository defaultWalletRepository;

  UpdateBudgetUseCase(
      {@required this.budgetRepository,
      @required this.defaultWalletRepository});

  Future<Either<Failure, void>> update({@required Budget updateBudget}) async {
    return await budgetRepository.update(updateBudget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updatePlanned(
      String categoryId, String budgetId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final budget =
        Budget(walletId: walletId, budgetId: budgetId, categoryId: categoryId);
    return await update(updateBudget: budget);
  }

  /// Updates the date meant for
  Future<Either<Failure, void>> updateDateMeantFor(
      String dateMeantFor, String budgetId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final budget = Budget(
        walletId: walletId, budgetId: budgetId, dateMeantFor: dateMeantFor);
    return await update(updateBudget: budget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      String categoryId, String budgetId) async {
    var defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    var walletId = defaultWalletResponse.getOrElse(null);
    final budget =
        Budget(walletId: walletId, budgetId: budgetId, categoryId: categoryId);
    return await update(updateBudget: budget);
  }
}
