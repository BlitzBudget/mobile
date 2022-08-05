import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

class BudgetResponseModel extends BudgetResponse {
  const BudgetResponseModel(
      {List<Budget>? budgets,
      List<Category>? categories,
      List<BankAccount>? bankAccounts,
      List<Date>? dates,
      Wallet? wallet})
      : super(
            budgets: budgets,
            categories: categories,
            bankAccounts: bankAccounts,
            dates: dates,
            wallet: wallet);

  factory BudgetResponseModel.fromJSON(List<dynamic> budgetResponseModel) {
    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final convertedBudgets = List<Budget>.from(budgetResponseModel
        .map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)));

    return BudgetResponseModel(budgets: convertedBudgets);
  }
}
