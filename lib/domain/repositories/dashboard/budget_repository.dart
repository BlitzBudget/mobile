import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';

abstract class BudgetRepository {
  Future<Either<Failure, void>> update(Budget updateBudget);

  Future<Either<Failure, void>> add(Budget addBudget);

  Future<Either<Failure, BudgetResponse>> fetch(
      {@required String startsWithDate,
      @required String endsWithDate,
      @required String defaultWallet,
      @required String userId});
}
