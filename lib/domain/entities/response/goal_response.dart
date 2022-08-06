import 'package:equatable/equatable.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';

class GoalResponse extends Equatable {
  const GoalResponse({this.goals});

  final List<Goal>? goals;

  @override
  List<Object?> get props => [goals];
}
