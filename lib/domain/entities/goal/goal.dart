import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  // Mandatory wallet ID
  const Goal(
      {this.walletId,
      this.goalId,
      this.currentAmount,
      this.targetAmount,
      this.targetDate,
      this.goalName,
      this.goalAchieved,
      this.creationDate,
      this.updateDate});

  final String? walletId;
  final String? goalId;
  final double? currentAmount;
  final double? targetAmount;
  final String? targetDate;
  final String? goalName;
  final bool? goalAchieved;
  final String? creationDate;
  final String? updateDate;

  @override
  List<Object?> get props => [
        walletId,
        goalId,
        currentAmount,
        targetAmount,
        targetDate,
        goalName,
        goalAchieved,
        creationDate,
        updateDate
      ];
}
