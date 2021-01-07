import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../date_model_test.dart';

class BudgetResponseModel extends BudgetResponse {
  BudgetResponseModel(
      {List<Budget> budgets,
      List<Category> categories,
      List<BankAccount> bankAccounts,
      List<Date> dates,
      Wallet wallet})
      : super(
            budgets: budgets,
            categories: categories,
            bankAccounts: bankAccounts,
            dates: dates,
            wallet: wallet);

  factory BudgetResponseModel.fromJSON(
      Map<String, dynamic> budgetResponseModel) {
    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    var responseBudgets = budgetResponseModel['Budget'] as List;
    var convertedBudgets = List<Budget>.from(responseBudgets?.map<dynamic>(
            (dynamic model) =>
                BudgetModel.fromJSON(model as Map<String, dynamic>)) ??
        <Budget>[]);

    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    var responseCategories = budgetResponseModel['Category'] as List;
    var convertedCategories = List<Category>.from(
        responseCategories?.map<dynamic>((dynamic model) =>
                CategoryModel.fromJSON(model as Map<String, dynamic>)) ??
            <Category>[]);

    /// Convert BankAccount from the response JSON to List<BankAccount>
    /// If Empty then return an empty object list
    var responseBankAccounts = budgetResponseModel['BankAccount'] as List;
    var convertedBankAccounts = List<BankAccount>.from(
        responseBankAccounts?.map<dynamic>((dynamic model) =>
                BankAccountModel.fromJSON(model as Map<String, dynamic>)) ??
            <BankAccount>[]);

    /// Convert Dates from the response JSON to List<Date>
    /// If Empty then return an empty object list
    var responseDate = budgetResponseModel['Date'] as List;
    var convertedDates = List<Date>.from(responseDate?.map<dynamic>(
            (dynamic model) =>
                DateModel.fromJSON(model as Map<String, dynamic>)) ??
        <Date>[]);

    dynamic responseWallet = budgetResponseModel['Wallet'];
    Wallet convertedWallet;

    /// Check if the response is a string or a list
    ///
    /// If string then convert them into a wallet
    /// If List then convert them into list of wallets and take the first wallet.
    if (responseWallet is Map) {
      convertedWallet =
          WalletModel.fromJSON(responseWallet as Map<String, dynamic>);
    } else if (responseWallet is List) {
      var convertedWallets = List<Wallet>.from(responseWallet.map<dynamic>(
          (dynamic model) =>
              WalletModel.fromJSON(model as Map<String, dynamic>)));

      convertedWallet = convertedWallets[0];
    }
    return BudgetResponseModel(
        budgets: convertedBudgets,
        categories: convertedCategories,
        bankAccounts: convertedBankAccounts,
        dates: convertedDates,
        wallet: convertedWallet);
  }
}
