import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';

abstract class BudgetRepository {
  Future<Either<Failure, void>> update(Budget updateBudget);

  Future<Either<Failure, void>> add(Budget addBudget);

  Future<Either<Failure, BudgetResponse>> get(String startsWithDate,
      String endsWithDate, String defaultWallet, String userId);
}
