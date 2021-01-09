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
      jsonDecode(budgetResponseModelAsString) as Map<String, dynamic>;

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  var budgetResponseModel = convertToResponseModel(budgetResponseModelAsJSON);

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
              as Map<String, dynamic>;

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
              as Map<String, dynamic>;

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
              as Map<String, dynamic>;

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
              as Map<String, dynamic>;

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
  var responseBudgets = budgetResponseModelAsJSON['Budget'] as List;
  var convertedBudgets = List<Budget>.from(responseBudgets?.map<dynamic>(
          (dynamic model) =>
              BudgetModel.fromJSON(model as Map<String, dynamic>)) ??
      <Budget>[]);

  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  var responseCategories = budgetResponseModelAsJSON['Category'] as List;
  var convertedCategories = List<Category>.from(
      responseCategories?.map<dynamic>((dynamic model) =>
              CategoryModel.fromJSON(model as Map<String, dynamic>)) ??
          <Category>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  var responseBankAccounts = budgetResponseModelAsJSON['BankAccount'] as List;
  var convertedBankAccounts = List<BankAccount>.from(
      responseBankAccounts?.map<dynamic>((dynamic model) =>
              BankAccountModel.fromJSON(model as Map<String, dynamic>)) ??
          <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  var responseDate = budgetResponseModelAsJSON['Date'] as List;
  var convertedDates = List<Date>.from(responseDate?.map<dynamic>(
          (dynamic model) =>
              DateModel.fromJSON(model as Map<String, dynamic>)) ??
      <Date>[]);

  dynamic responseWallet = budgetResponseModelAsJSON['Wallet'];
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

  final budgetResponseModel = BudgetResponseModel(
      budgets: convertedBudgets,
      categories: convertedCategories,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet);
  return budgetResponseModel;
}
