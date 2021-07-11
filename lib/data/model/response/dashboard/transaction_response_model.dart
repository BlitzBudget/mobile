import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/recurring-transaction/recurring_transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/response/transaction_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../date_model.dart';

class TransactionResponseModel extends TransactionResponse {
  const TransactionResponseModel(
      {List<Transaction> transactions,
      List<Budget> budgets,
      List<Category> categories,
      List<BankAccount> bankAccounts,
      List<RecurringTransaction> recurringTransactions,
      List<Date> dates,
      Wallet wallet,
      double incomeTotal,
      double expenseTotal,
      double balance})
      : super(
            transactions: transactions,
            budgets: budgets,
            categories: categories,
            bankAccounts: bankAccounts,
            recurringTransactions: recurringTransactions,
            dates: dates,
            wallet: wallet,
            incomeTotal: incomeTotal,
            expenseTotal: expenseTotal,
            balance: balance);

  factory TransactionResponseModel.fromJSON(
      Map<String, dynamic> transactionResponseModel) {
    /// Convert transactions from the response JSON to List<Transaction>
    /// If Empty then return an empty object list
    final responseTransactions = transactionResponseModel['Transaction'];
    final convertedTransactions = List<Transaction>.from(
        responseTransactions?.map<dynamic>(
                (dynamic model) => TransactionModel.fromJSON(model)) ??
            <Transaction>[]);

    /// Convert recurring transactions from the response JSON to List<RecurringTransaction>
    /// If Empty then return an empty object list
    final responseRecurringTransactions =
        transactionResponseModel['RecurringTransactions'];
    final convertedRecurringTransactions = List<RecurringTransaction>.from(
        responseRecurringTransactions?.map<dynamic>(
                (dynamic model) => RecurringTransactionModel.fromJSON(model)) ??
            <RecurringTransaction>[]);

    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final responseBudgets = transactionResponseModel['Budget'];
    final convertedBudgets = List<Budget>.from(responseBudgets
            ?.map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)) ??
        <Budget>[]);

    /// Convert categories from the response JSON to List<Category>
    /// If Empty then return an empty object list
    final responseCategories = transactionResponseModel['Category'];
    final convertedCategories = List<Category>.from(responseCategories
            ?.map<dynamic>((dynamic model) => CategoryModel.fromJSON(model)) ??
        <Category>[]);

    /// Convert BankAccount from the response JSON to List<BankAccount>
    /// If Empty then return an empty object list
    final responseBankAccounts = transactionResponseModel['BankAccount'];
    final convertedBankAccounts = List<BankAccount>.from(
        responseBankAccounts?.map<dynamic>(
                (dynamic model) => BankAccountModel.fromJSON(model)) ??
            <BankAccount>[]);

    /// Convert Dates from the response JSON to List<Date>
    /// If Empty then return an empty object list
    final responseDate = transactionResponseModel['Date'];
    final convertedDates = List<Date>.from(responseDate
            ?.map<dynamic>((dynamic model) => DateModel.fromJSON(model)) ??
        <Date>[]);

    final responseWallet = transactionResponseModel['Wallet'];
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

    return TransactionResponseModel(
        transactions: convertedTransactions,
        recurringTransactions: convertedRecurringTransactions,
        budgets: convertedBudgets,
        categories: convertedCategories,
        bankAccounts: convertedBankAccounts,
        dates: convertedDates,
        wallet: convertedWallet,
        incomeTotal:
            parseDynamicAsDouble(transactionResponseModel['incomeTotal']),
        expenseTotal:
            parseDynamicAsDouble(transactionResponseModel['expenseTotal']),
        balance: parseDynamicAsDouble(transactionResponseModel['balance']));
  }
}
