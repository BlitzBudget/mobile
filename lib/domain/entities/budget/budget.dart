import 'package:equatable/equatable.dart';

import '../category/category_type.dart' show CategoryType;

class Budget extends Equatable {
  final String budgetId;
  final String walletId;
  final double planned;
  final double used;
  final String dateMeantFor;
  final String category;
  final CategoryType categoryType;

  // Optional category type and Budget id fields
  Budget(
      {this.walletId,
      this.planned,
      this.dateMeantFor,
      this.category,
      this.categoryType,
      this.budgetId,
      this.used});

  @override
  List<Object> get props =>
      [budgetId, walletId, planned, used, dateMeantFor, category, categoryType];
}
