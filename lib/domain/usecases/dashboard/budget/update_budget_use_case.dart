import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';

class UpdateBudgetUseCase {
  BudgetRepository budgetRepository;
  Future<Either<Failure, void>> update({@required Budget updateBudget}) async {
    return await budgetRepository.update(updateBudget);
  }
}
