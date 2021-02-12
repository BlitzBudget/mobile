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

import '../../date_model.dart';

class BudgetResponseModel extends BudgetResponse {
  const BudgetResponseModel(
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
    final responseBudgets = budgetResponseModel['Budget'];
    final convertedBudgets = List<Budget>.from(responseBudgets
            ?.map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)) ??
        <Budget>[]);

    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    final responseCategories = budgetResponseModel['Category'];
    final convertedCategories = List<Category>.from(responseCategories
            ?.map<dynamic>((dynamic model) => CategoryModel.fromJSON(model)) ??
        <Category>[]);

    /// Convert BankAccount from the response JSON to List<BankAccount>
    /// If Empty then return an empty object list
    final responseBankAccounts = budgetResponseModel['BankAccount'];
    final convertedBankAccounts = List<BankAccount>.from(
        responseBankAccounts?.map<dynamic>(
                (dynamic model) => BankAccountModel.fromJSON(model)) ??
            <BankAccount>[]);

    /// Convert Dates from the response JSON to List<Date>
    /// If Empty then return an empty object list
    final responseDate = budgetResponseModel['Date'];
    final convertedDates = List<Date>.from(responseDate
            ?.map<dynamic>((dynamic model) => DateModel.fromJSON(model)) ??
        <Date>[]);

    final responseWallet = budgetResponseModel['Wallet'];
    Wallet convertedWallet;

    /// Check if the response is a string or a list
    ///
    /// If string then convert them into a wallet
    /// If List then convert them into list of wallets and take the first wallet.
    if (responseWallet is Map) {
      convertedWallet = WalletModel.fromJSON(responseWallet);
    } else if (responseWallet is List) {
      final convertedWallets = List<Wallet>.from(responseWallet
          .map<dynamic>((dynamic model) => WalletModel.fromJSON(model)));

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
