import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/default_wallet_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/use_case.dart';

class UpdateBudgetUseCase extends UseCase {
  UpdateBudgetUseCase(
      {required this.budgetRepository, required this.defaultWalletRepository});

  late final BudgetRepository budgetRepository;
  late final DefaultWalletRepository defaultWalletRepository;

  Future<Either<Failure, void>> _update({required Budget updateBudget}) async {
    return budgetRepository.update(updateBudget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updatePlanned(
      {required double? planned, required String? budgetId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final budget =
        Budget(walletId: walletId, budgetId: budgetId, planned: planned);
    return _update(updateBudget: budget);
  }

  /// Updates the category id
  Future<Either<Failure, void>> updateCategoryId(
      {required String? categoryId, required String? budgetId}) async {
    final defaultWalletResponse =
        await defaultWalletRepository.readDefaultWallet();
    if (defaultWalletResponse.isLeft()) {
      return Left(EmptyResponseFailure());
    }
    final walletId = defaultWalletResponse.getOrElse(() => '');
    final budget =
        Budget(walletId: walletId, budgetId: budgetId, categoryId: categoryId);
    return _update(updateBudget: budget);
  }
}
