import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
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
  OverviewResponseModel(
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
      Map<String, dynamic> transactionResponseModel) {
    /// Convert transactions from the response JSON to List<Transaction>
    var responseTransactions = transactionResponseModel['Transaction'] as List;
    var convertedTransactions = List<Transaction>.from(
        responseTransactions.map<dynamic>((dynamic model) =>
            TransactionModel.fromJSON(model as Map<String, dynamic>)));

    /// Convert budgets from the response JSON to List<Budget>
    var responseBudgets = transactionResponseModel['Budget'] as List;
    var convertedBudgets = List<Budget>.from(responseBudgets.map<dynamic>(
        (dynamic model) =>
            BudgetModel.fromJSON(model as Map<String, dynamic>)));

    /// Convert categories from the response JSON to List<Category>
    var responseCategories = transactionResponseModel['Category'] as List;
    var convertedCategories = List<Category>.from(
        responseCategories.map<dynamic>((dynamic model) =>
            CategoryModel.fromJSON(model as Map<String, dynamic>)));

    /// Convert BankAccount from the response JSON to List<BankAccount>
    var responseBankAccounts = transactionResponseModel['BankAccount'] as List;
    var convertedBankAccounts = List<BankAccount>.from(
        responseBankAccounts.map<dynamic>((dynamic model) =>
            BankAccountModel.fromJSON(model as Map<String, dynamic>)));

    /// Convert Dates from the response JSON to List<Date>
    var responseDate = transactionResponseModel['Date'] as List;
    var convertedDates = List<Date>.from(responseDate.map<dynamic>(
        (dynamic model) => DateModel.fromJSON(model as Map<String, dynamic>)));

    dynamic responseWallet = transactionResponseModel['Wallet'];
    Wallet convertedWallet;

    /// Check if the response is a string or a list
    ///
    /// If string then convert them into a wallet
    /// If List then convert them into list of wallets and take the first wallet.
    if (responseWallet is String) {
      convertedWallet =
          WalletModel.fromJSON(responseWallet as Map<String, dynamic>);
    } else if (responseWallet is List) {
      var convertedWallets = List<Wallet>.from(responseWallet.map<dynamic>(
          (dynamic model) =>
              WalletModel.fromJSON(model as Map<String, dynamic>)));

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
