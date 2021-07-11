import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/transaction_response_model.dart';
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

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final transactionResponseModelAsString =
      fixture('responses/dashboard/transaction/fetch_transaction_info.json');
  final transactionResponseModelAsJSON =
      jsonDecode(transactionResponseModelAsString);

  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final transactionResponseModel =
      convertToResponseModel(transactionResponseModelAsJSON);

  test(
    'Should be a subclass of TransactionModel entity',
    () async {
      // assert
      expect(transactionResponseModel, isA<TransactionResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final transactionModelConverted =
          TransactionResponseModel.fromJSON(transactionResponseModelAsJSON);
      expect(transactionModelConverted, equals(transactionResponseModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty bank account data',
        () async {
      final transactionResponseModelWithEmptyBankAccountAsString = fixture(
          'responses/partially-emtpy/transaction/empty_bank_account_transaction_info.json');
      final transactionResponseModelWithEmptyBankAccountAsJSON =
          jsonDecode(transactionResponseModelWithEmptyBankAccountAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithEmptyBankAccountConverted =
          convertToResponseModel(
              transactionResponseModelWithEmptyBankAccountAsJSON);
      final transactionResponseModelWithEmptyBankAccountFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithEmptyBankAccountAsJSON);
      expect(transactionResponseModelWithEmptyBankAccountFromJSON,
          equals(transactionResponseModelWithEmptyBankAccountConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty budget data',
        () async {
      final transactionResponseModelWithEmptyBudgetAsString = fixture(
          'responses/partially-emtpy/transaction/empty_budget_transaction_info.json');
      final transactionResponseModelWithEmptyBudgetAsJSON =
          jsonDecode(transactionResponseModelWithEmptyBudgetAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithEmptyBudgetConverted =
          convertToResponseModel(transactionResponseModelWithEmptyBudgetAsJSON);
      final transactionResponseModelWithEmptyBudgetFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithEmptyBudgetAsJSON);
      expect(transactionResponseModelWithEmptyBudgetFromJSON,
          equals(transactionResponseModelWithEmptyBudgetConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty category data',
        () async {
      final transactionResponseModelWithEmptyCategoryAsString = fixture(
          'responses/partially-emtpy/transaction/empty_category_transaction_info.json');
      final transactionResponseModelWithEmptyCategoryAsJSON =
          jsonDecode(transactionResponseModelWithEmptyCategoryAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithEmptyCategoryConverted =
          convertToResponseModel(
              transactionResponseModelWithEmptyCategoryAsJSON);
      final transactionResponseModelWithEmptyCategoryFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithEmptyCategoryAsJSON);
      expect(transactionResponseModelWithEmptyCategoryFromJSON,
          equals(transactionResponseModelWithEmptyCategoryConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty date data',
        () async {
      final transactionResponseModelWithEmptyDateAsString = fixture(
          'responses/partially-emtpy/transaction/empty_date_transaction_info.json');
      final transactionResponseModelWithEmptyDateAsJSON =
          jsonDecode(transactionResponseModelWithEmptyDateAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithEmptyDateConverted =
          convertToResponseModel(transactionResponseModelWithEmptyDateAsJSON);
      final transactionResponseModelWithEmptyDateFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithEmptyDateAsJSON);
      expect(transactionResponseModelWithEmptyDateFromJSON,
          equals(transactionResponseModelWithEmptyDateConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty recurring transaction data',
        () async {
      final transactionResponseModelWithEmptyRecurringTransactionAsString = fixture(
          'responses/partially-emtpy/transaction/empty_recurring_transaction_transaction_info.json');
      final transactionResponseModelWithEmptyRecurringTransactionAsJSON =
          jsonDecode(
              transactionResponseModelWithEmptyRecurringTransactionAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithEmptyRecurringTransactionConverted =
          convertToResponseModel(
              transactionResponseModelWithEmptyRecurringTransactionAsJSON);
      final transactionResponseModelWithEmptyRecurringTransactionFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithEmptyRecurringTransactionAsJSON);
      expect(
          transactionResponseModelWithEmptyRecurringTransactionFromJSON,
          equals(
              transactionResponseModelWithEmptyRecurringTransactionConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty transaction data',
        () async {
      final transactionResponseModelWithEmptyTransactionAsString = fixture(
          'responses/partially-emtpy/transaction/empty_transaction_transaction_info.json');
      final transactionResponseModelWithEmptyTransactionAsJSON =
          jsonDecode(transactionResponseModelWithEmptyTransactionAsString);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithEmptyTransactionConverted =
          convertToResponseModel(
              transactionResponseModelWithEmptyTransactionAsJSON);
      final transactionResponseModelWithEmptyTransactionFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithEmptyTransactionAsJSON);
      expect(transactionResponseModelWithEmptyTransactionFromJSON,
          equals(transactionResponseModelWithEmptyTransactionConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with wallet list data',
        () async {
      final transactionResponseModelWithWalletAsList = fixture(
          'responses/dashboard/transaction/with-wallet-data/wallet_as_list.json');
      final transactionResponseModelWithWalletAsListJSON =
          jsonDecode(transactionResponseModelWithWalletAsList);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithWalletAsListConverted =
          convertToResponseModel(transactionResponseModelWithWalletAsListJSON);
      final transactionResponseModelWithWalletAsListFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithWalletAsListJSON);
      expect(transactionResponseModelWithWalletAsListFromJSON,
          equals(transactionResponseModelWithWalletAsListConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with wallet map data',
        () async {
      final transactionResponseModelWithWalletAsMap = fixture(
          'responses/dashboard/transaction/with-wallet-data/wallet_as_map.json');
      final transactionResponseModelWithWalletAsMapJSON =
          jsonDecode(transactionResponseModelWithWalletAsMap);

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final transactionResponseModelWithWalletAsMapConverted =
          convertToResponseModel(transactionResponseModelWithWalletAsMapJSON);
      final transactionResponseModelWithWalletAsMapFromJSON =
          TransactionResponseModel.fromJSON(
              transactionResponseModelWithWalletAsMapJSON);
      expect(transactionResponseModelWithWalletAsMapFromJSON,
          equals(transactionResponseModelWithWalletAsMapConverted));
    });
  });
}

TransactionResponseModel convertToResponseModel(
    Map<String, dynamic> transactionResponseModelAsJSON) {
  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final responseTransactions = transactionResponseModelAsJSON['Transaction'];
  final convertedTransactions = List<Transaction>.from(responseTransactions
          ?.map<dynamic>((dynamic model) => TransactionModel.fromJSON(model)) ??
      <Transaction>[]);

  /// Convert recurring transactions from the response JSON to List<RecurringTransaction>
  /// If Empty then return an empty object list
  final responseRecurringTransactions =
      transactionResponseModelAsJSON['RecurringTransactions'];
  final convertedRecurringTransactions = List<RecurringTransaction>.from(
      responseRecurringTransactions?.map<dynamic>(
              (dynamic model) => RecurringTransactionModel.fromJSON(model)) ??
          <RecurringTransaction>[]);

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final responseBudgets = transactionResponseModelAsJSON['Budget'];
  final convertedBudgets = List<Budget>.from(responseBudgets
          ?.map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)) ??
      <Budget>[]);

  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  final responseCategories = transactionResponseModelAsJSON['Category'];
  final convertedCategories = List<Category>.from(responseCategories
          ?.map<dynamic>((dynamic model) => CategoryModel.fromJSON(model)) ??
      <Category>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  final responseBankAccounts = transactionResponseModelAsJSON['BankAccount'];
  final convertedBankAccounts = List<BankAccount>.from(responseBankAccounts
          ?.map<dynamic>((dynamic model) => BankAccountModel.fromJSON(model)) ??
      <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  final responseDate = transactionResponseModelAsJSON['Date'];
  final convertedDates = List<Date>.from(responseDate
          ?.map<dynamic>((dynamic model) => DateModel.fromJSON(model)) ??
      <Date>[]);

  final responseWallet = transactionResponseModelAsJSON['Wallet'];
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
          parseDynamicAsDouble(transactionResponseModelAsJSON['incomeTotal']),
      expenseTotal:
          parseDynamicAsDouble(transactionResponseModelAsJSON['expenseTotal']),
      balance: parseDynamicAsDouble(transactionResponseModelAsJSON['balance']));
}
