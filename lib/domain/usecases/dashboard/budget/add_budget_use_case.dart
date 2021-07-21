import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/budget_repository.dart';

import '../../use_case.dart';

class AddBudgetUseCase extends UseCase {
  AddBudgetUseCase({required this.budgetRepository});

  final BudgetRepository? budgetRepository;

  Future<Either<Failure, void>> add({required Budget addBudget}) async {
    return budgetRepository!.add(addBudget);
  }
}
