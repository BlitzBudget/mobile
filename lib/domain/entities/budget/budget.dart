import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  // Optional category type and Budget id fields
  const Budget(
      {this.walletId,
      this.planned,
      this.categoryId,
      this.budgetId,
      this.creationDate});

  final String? budgetId;
  final String? walletId;
  final double? planned;
  final String? categoryId;
  final String? creationDate;

  @override
  List<Object?> get props =>
      [budgetId, walletId, planned, categoryId, creationDate];
}
