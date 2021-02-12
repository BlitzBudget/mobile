import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../date_model.dart';

class OverviewResponseModel extends OverviewResponse {
  const OverviewResponseModel(
      {List<Transaction> transactions,
      List<Budget> budgets,
      List<Category> categories,
      List<BankAccount> bankAccounts,
      List<Date> dates,
      Wallet wallet})
      : super(
            transactions: transactions,
            budgets: budgets,
            categories: categories,
            bankAccounts: bankAccounts,
            dates: dates,
            wallet: wallet);

  factory OverviewResponseModel.fromJSON(
      Map<String, dynamic> overviewResponseModel) {
    /// Convert transactions from the response JSON to List<Transaction>
    /// If Empty then return an empty object list
    final responseTransactions = overviewResponseModel['Transaction'];
    final convertedTransactions = List<Transaction>.from(
        responseTransactions?.map<dynamic>(
                (dynamic model) => TransactionModel.fromJSON(model)) ??
            <Transaction>[]);

    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final responseBudgets = overviewResponseModel['Budget'];
    final convertedBudgets = List<Budget>.from(responseBudgets
            ?.map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)) ??
        <Budget>[]);

    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    final responseCategories = overviewResponseModel['Category'];
    final convertedCategories = List<Category>.from(responseCategories
            ?.map<dynamic>((dynamic model) => CategoryModel.fromJSON(model)) ??
        <Category>[]);

    /// Convert BankAccount from the response JSON to List<BankAccount>
    /// If Empty then return an empty object list
    final responseBankAccounts = overviewResponseModel['BankAccount'];
    final convertedBankAccounts = List<BankAccount>.from(
        responseBankAccounts?.map<dynamic>(
                (dynamic model) => BankAccountModel.fromJSON(model)) ??
            <BankAccount>[]);

    /// Convert Dates from the response JSON to List<Date>
    /// If Empty then return an empty object list
    final responseDate = overviewResponseModel['Date'];
    final convertedDates = List<Date>.from(responseDate
            ?.map<dynamic>((dynamic model) => DateModel.fromJSON(model)) ??
        <Date>[]);

    final responseWallet = overviewResponseModel['Wallet'];
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
    return OverviewResponseModel(
        transactions: convertedTransactions,
        budgets: convertedBudgets,
        categories: convertedCategories,
        bankAccounts: convertedBankAccounts,
        dates: convertedDates,
        wallet: convertedWallet);
  }
}
