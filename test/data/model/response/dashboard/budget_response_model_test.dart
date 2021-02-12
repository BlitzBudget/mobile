import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/budget_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/response/budget_response.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final budgetResponseModelAsString =
      fixture('responses/dashboard/budget/fetch_budget_info.json');
  final budgetResponseModelAsJSON =
      jsonDecode(budgetResponseModelAsString);

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final budgetResponseModel = convertToResponseModel(budgetResponseModelAsJSON);

  test(
    'Should be a subclass of BudgetModel entity',
    () async {
      // assert
      expect(budgetResponseModel, isA<BudgetResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final budgetModelConverted =
          BudgetResponseModel.fromJSON(budgetResponseModelAsJSON);
      expect(budgetModelConverted, equals(budgetResponseModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty budget data',
        () async {
      final budgetResponseModelWithEmptyBudgetAsString = fixture(
          'responses/partially-emtpy/budget/empty_budget_budget_info.json');
      final budgetResponseModelWithEmptyBudgetAsJSON =
          jsonDecode(budgetResponseModelWithEmptyBudgetAsString)
              ;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final budgetResponseModelWithEmptyBudgetConverted =
          convertToResponseModel(budgetResponseModelWithEmptyBudgetAsJSON);
      final budgetResponseModelWithEmptyBudgetFromJSON =
          BudgetResponseModel.fromJSON(
              budgetResponseModelWithEmptyBudgetAsJSON);
      expect(budgetResponseModelWithEmptyBudgetFromJSON,
          equals(budgetResponseModelWithEmptyBudgetConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty bank account data',
        () async {
      final budgetResponseModelWithEmptyBankAccountAsString = fixture(
          'responses/partially-emtpy/budget/empty_bank_account_budget_info.json');
      final budgetResponseModelWithEmptyBankAccountAsJSON =
          jsonDecode(budgetResponseModelWithEmptyBankAccountAsString)
              ;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final budgetResponseModelWithEmptyBankAccountConverted =
          convertToResponseModel(budgetResponseModelWithEmptyBankAccountAsJSON);
      final budgetResponseModelWithEmptyBankAccountFromJSON =
          BudgetResponseModel.fromJSON(
              budgetResponseModelWithEmptyBankAccountAsJSON);
      expect(budgetResponseModelWithEmptyBankAccountFromJSON,
          equals(budgetResponseModelWithEmptyBankAccountConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty category data',
        () async {
      final budgetResponseModelWithEmptyCategoryAsString = fixture(
          'responses/partially-emtpy/budget/empty_category_budget_info.json');
      final budgetResponseModelWithEmptyCategoryAsJSON =
          jsonDecode(budgetResponseModelWithEmptyCategoryAsString)
               ;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final budgetResponseModelWithEmptyCategoryConverted =
          convertToResponseModel(budgetResponseModelWithEmptyCategoryAsJSON);
      final budgetResponseModelWithEmptyCategoryFromJSON =
          BudgetResponseModel.fromJSON(
              budgetResponseModelWithEmptyCategoryAsJSON);
      expect(budgetResponseModelWithEmptyCategoryFromJSON,
          equals(budgetResponseModelWithEmptyCategoryConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty date data',
        () async {
      final budgetResponseModelWithEmptyDateAsString = fixture(
          'responses/partially-emtpy/budget/empty_date_budget_info.json');
      final budgetResponseModelWithEmptyDateAsJSON =
          jsonDecode(budgetResponseModelWithEmptyDateAsString)
            ;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final budgetResponseModelWithEmptyDateConverted =
          convertToResponseModel(budgetResponseModelWithEmptyDateAsJSON);
      final budgetResponseModelWithEmptyDateFromJSON =
          BudgetResponseModel.fromJSON(budgetResponseModelWithEmptyDateAsJSON);
      expect(budgetResponseModelWithEmptyDateFromJSON,
          equals(budgetResponseModelWithEmptyDateConverted));
    });
  });
}

BudgetResponseModel convertToResponseModel(
    Map<String, dynamic> budgetResponseModelAsJSON) {
  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final responseBudgets = budgetResponseModelAsJSON['Budget'];
  final convertedBudgets = List<Budget>.from(responseBudgets?.map<dynamic>(
          (dynamic model) =>
              BudgetModel.fromJSON(model)) ??
      <Budget>[]);

  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  final responseCategories = budgetResponseModelAsJSON['Category'];
  final convertedCategories = List<Category>.from(
      responseCategories?.map<dynamic>((dynamic model) =>
              CategoryModel.fromJSON(model)) ??
          <Category>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  final responseBankAccounts = budgetResponseModelAsJSON['BankAccount'];
  final convertedBankAccounts = List<BankAccount>.from(
      responseBankAccounts?.map<dynamic>((dynamic model) =>
              BankAccountModel.fromJSON(model)) ??
          <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  final responseDate = budgetResponseModelAsJSON['Date'];
  final convertedDates = List<Date>.from(responseDate?.map<dynamic>(
          (dynamic model) =>
              DateModel.fromJSON(model)) ??
      <Date>[]);

  final responseWallet = budgetResponseModelAsJSON['Wallet'];
  Wallet convertedWallet;

  /// Check if the response is a string or a list
  ///
  /// If string then convert them into a wallet
  /// If List then convert them into list of wallets and take the first wallet.
  if (responseWallet is Map) {
    convertedWallet =
        WalletModel.fromJSON(responseWallet);
  } else if (responseWallet is List) {
    final convertedWallets = List<Wallet>.from(responseWallet.map<dynamic>(
        (dynamic model) =>
            WalletModel.fromJSON(model)));

    convertedWallet = convertedWallets[0];
  }

  final budgetResponseModel = BudgetResponseModel(
      budgets: convertedBudgets,
      categories: convertedCategories,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet);
  return budgetResponseModel;
}
