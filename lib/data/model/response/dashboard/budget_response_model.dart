import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';

class BudgetResponseModel extends BudgetResponse {
  const BudgetResponseModel({List<Budget>? budgets}) : super(budgets: budgets);

  factory BudgetResponseModel.fromJSON(List<dynamic> budgetResponseModel) {
    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final convertedBudgets = List<Budget>.from(budgetResponseModel
        .map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)));

    return BudgetResponseModel(budgets: convertedBudgets);
  }
}
