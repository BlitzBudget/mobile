import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/error/failure.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';

abstract class BudgetRepository {
  Future<Either<Failure, void>> update(BudgetModel updateBudget);

  Future<Either<Failure, void>> add(BudgetModel addBudget);

  Future<Either<Failure, void>> get(String walletId, String account);
}
