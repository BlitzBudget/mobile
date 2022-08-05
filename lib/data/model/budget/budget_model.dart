import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

class BudgetModel extends Budget {
  // Optional category type and Budget id fields
  const BudgetModel({
    String? budgetId,
    String? walletId,
    double? planned,
    String? category,
  }) : super(
            walletId: walletId,
            planned: planned,
            categoryId: category,
            budgetId: budgetId);

  /// Map JSON Budget to List of object
  factory BudgetModel.fromJSON(Map<String, dynamic> budget) {
    return BudgetModel(
        budgetId: parseDynamicAsString(budget['sk']),
        walletId: parseDynamicAsString(budget['pk']),
        planned: parseDynamicAsDouble(budget['planned']),
        category: parseDynamicAsString(budget['category']),);
  }

  /// Budget to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'pk': walletId,
        'sk': budgetId,
        'planned': planned,
        'category': categoryId,
      };
}
