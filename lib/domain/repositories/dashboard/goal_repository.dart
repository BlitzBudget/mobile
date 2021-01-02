import 'package:dartz/dartz.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';

abstract class GoalRepository {
  Future<Either<Failure, void>> add(GoalModel addGoal);
  Future<Either<Failure, void>> update(GoalModel updateGoal);
}
