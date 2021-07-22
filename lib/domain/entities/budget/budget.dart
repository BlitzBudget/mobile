import 'package:equatable/equatable.dart';

import '../category/category_type.dart' show CategoryType;

class Budget extends Equatable {
  // Optional category type and Budget id fields
  const Budget(
      {this.walletId,
      this.planned,
      this.dateMeantFor,
      this.categoryId,
      this.categoryType,
      this.budgetId,
      this.used});

  final String? budgetId;
  final String? walletId;
  final double? planned;
  final double? used;
  final String? dateMeantFor;
  final String? categoryId;
  final CategoryType? categoryType;

  @override
  List<Object?> get props => [
        budgetId,
        walletId,
        planned,
        used,
        dateMeantFor,
        categoryId,
        categoryType
      ];
}
