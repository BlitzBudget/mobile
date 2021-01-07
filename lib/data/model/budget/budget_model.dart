import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category_type.dart';

class BudgetModel extends Budget {
  // Optional category type and Budget id fields
  BudgetModel({
    String budgetId,
    String walletId,
    double planned,
    double used,
    String dateMeantFor,
    String category,
    CategoryType categoryType,
  }) : super(
            walletId: walletId,
            planned: planned,
            dateMeantFor: dateMeantFor,
            categoryId: category,
            categoryType: categoryType,
            budgetId: budgetId,
            used: used);

  /// Map JSON Budget to List of object
  factory BudgetModel.fromJSON(Map<String, dynamic> budget) {
    return BudgetModel(
        budgetId: parseDynamicAsString(budget['budgetId']),
        walletId: parseDynamicAsString(budget['walletId']),
        planned: parseDynamicAsDouble(budget['planned']),
        used: parseDynamicAsDouble(budget['used']),
        category: parseDynamicAsString(budget['category']));
  }

  /// Budget to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'budgetId': budgetId,
        'dateMeantFor': dateMeantFor,
        'planned': planned,
        'category': categoryId,
        'categoryType': categoryType.name
      };
}
