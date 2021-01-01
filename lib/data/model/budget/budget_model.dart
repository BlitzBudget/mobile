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
            category: category,
            categoryType: categoryType,
            budgetId: budgetId,
            used: used);

  /// Map JSON Budget to List of object
  factory BudgetModel.fromJSON(Map<String, dynamic> budget) {
    return BudgetModel(
        budgetId: parseDynamicToString(budget['budgetId']),
        walletId: parseDynamicToString(budget['walletId']),
        planned: parseDynamicToDouble(budget['planned']),
        used: parseDynamicToDouble(budget['used']),
        category: parseDynamicToString(budget['category']));
  }

  /// Budget to JSON
  Map<String, dynamic> toJSON() => <String, dynamic>{
        'walletId': walletId,
        'budgetId': budgetId,
        'dateMeantFor': dateMeantFor,
        'planned': planned,
        'category': category,
        'categoryType': categoryType
      };
}
