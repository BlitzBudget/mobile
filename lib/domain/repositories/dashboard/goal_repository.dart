import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';

abstract class GoalRepository {
  Future<Either<Failure, GoalResponse>> fetch(
      {required String startsWithDate,
      required String endsWithDate,
      required String? defaultWallet,
      required String? userId});
  Future<Either<Failure, void>> add(Goal addGoal);
  Future<Either<Failure, void>> update(Goal updateGoal);
}
