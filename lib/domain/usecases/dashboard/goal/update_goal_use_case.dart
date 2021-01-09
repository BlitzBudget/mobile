import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/goal_repository.dart';

import '../../use_case.dart';

class UpdateGoalUseCase extends UseCase {
  final GoalRepository goalRepository;

  UpdateGoalUseCase({@required this.goalRepository});

  Future<Either<Failure, void>> update({@required Goal updateGoal}) async {
    return await goalRepository.update(updateGoal);
  }
}
