import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/overview_response_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final overviewResponseModelAsString =
      fixture('responses/dashboard/overview_info.json');
  final overviewResponseModelAsJSON = jsonDecode(overviewResponseModelAsString);

  /// Convert overviews from the response JSON to List<Overview>
  /// If Empty then return an empty object list
  final overviewResponseModel =
      convertToResponseModel(overviewResponseModelAsJSON);

  test(
    'Should be a subclass of OverviewModel entity',
    () async {
      // assert
      expect(overviewResponseModel, isA<OverviewResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final overviewModelConverted =
          OverviewResponseModel.fromJSON(overviewResponseModelAsJSON);
      expect(overviewModelConverted, equals(overviewResponseModel));
    });
  });

  test(
      'Should return a valid model when the JSON is parsed with empty bank account data',
      () async {
    final overviewResponseModelWithEmptyBankAccountAsString = fixture(
        'responses/partially-emtpy/overview/empty_bank_account_overview_info.json');
    final overviewResponseModelWithEmptyBankAccountAsJSON =
        jsonDecode(overviewResponseModelWithEmptyBankAccountAsString);

    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final overviewResponseModelWithEmptyBankAccountConverted =
        convertToResponseModel(overviewResponseModelWithEmptyBankAccountAsJSON);
    final overviewResponseModelWithEmptyBankAccountFromJSON =
        OverviewResponseModel.fromJSON(
            overviewResponseModelWithEmptyBankAccountAsJSON);
    expect(overviewResponseModelWithEmptyBankAccountFromJSON,
        equals(overviewResponseModelWithEmptyBankAccountConverted));
  });

  test(
      'Should return a valid model when the JSON is parsed with empty category data',
      () async {
    final overviewResponseModelWithEmptyCategoryAsString = fixture(
        'responses/partially-emtpy/overview/empty_category_overview_info.json');
    final overviewResponseModelWithEmptyCategoryAsJSON =
        jsonDecode(overviewResponseModelWithEmptyCategoryAsString);

    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final overviewResponseModelWithEmptyCategoryConverted =
        convertToResponseModel(overviewResponseModelWithEmptyCategoryAsJSON);
    final overviewResponseModelWithEmptyCategoryFromJSON =
        OverviewResponseModel.fromJSON(
            overviewResponseModelWithEmptyCategoryAsJSON);
    expect(overviewResponseModelWithEmptyCategoryFromJSON,
        equals(overviewResponseModelWithEmptyCategoryConverted));
  });

  test(
      'Should return a valid model when the JSON is parsed with empty date data',
      () async {
    final overviewResponseModelWithEmptyDateAsString = fixture(
        'responses/partially-emtpy/overview/empty_date_overview_info.json');
    final overviewResponseModelWithEmptyDateAsJSON =
        jsonDecode(overviewResponseModelWithEmptyDateAsString);

    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final overviewResponseModelWithEmptyDateConverted =
        convertToResponseModel(overviewResponseModelWithEmptyDateAsJSON);
    final overviewResponseModelWithEmptyDateFromJSON =
        OverviewResponseModel.fromJSON(
            overviewResponseModelWithEmptyDateAsJSON);
    expect(overviewResponseModelWithEmptyDateFromJSON,
        equals(overviewResponseModelWithEmptyDateConverted));
  });

  test(
      'Should return a valid model when the JSON is parsed with empty transaction data',
      () async {
    final overviewResponseModelWithEmptyTransactionAsString = fixture(
        'responses/partially-emtpy/overview/empty_transaction_overview_info.json');
    final overviewResponseModelWithEmptyTransactionAsJSON =
        jsonDecode(overviewResponseModelWithEmptyTransactionAsString);

    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final overviewResponseModelWithEmptyTransactionConverted =
        convertToResponseModel(overviewResponseModelWithEmptyTransactionAsJSON);
    final overviewResponseModelWithEmptyTransactionFromJSON =
        OverviewResponseModel.fromJSON(
            overviewResponseModelWithEmptyTransactionAsJSON);
    expect(overviewResponseModelWithEmptyTransactionFromJSON,
        equals(overviewResponseModelWithEmptyTransactionConverted));
  });

  test(
      'Should return a valid model when the JSON is parsed with empty wallet data',
      () async {
    final overviewResponseModelWithEmptyWalletAsString = fixture(
        'responses/partially-emtpy/overview/empty_wallet_overview_info.json');
    final overviewResponseModelWithEmptyWalletAsJSON =
        jsonDecode(overviewResponseModelWithEmptyWalletAsString);

    /// Convert budgets from the response JSON to List<Budget>
    /// If Empty then return an empty object list
    final overviewResponseModelWithEmptyWalletConverted =
        convertToResponseModel(overviewResponseModelWithEmptyWalletAsJSON);
    final overviewResponseModelWithEmptyWalletFromJSON =
        OverviewResponseModel.fromJSON(
            overviewResponseModelWithEmptyWalletAsJSON);
    expect(overviewResponseModelWithEmptyWalletFromJSON,
        equals(overviewResponseModelWithEmptyWalletConverted));
  });
}

OverviewResponseModel convertToResponseModel(
    Map<String, dynamic> overviewResponseModelAsJSON) {
  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  final responseTransactions = overviewResponseModelAsJSON['Transaction'];
  final convertedTransactions = List<Transaction>.from(responseTransactions
          ?.map<dynamic>((dynamic model) => TransactionModel.fromJSON(model)) ??
      <Transaction>[]);

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  final responseBudgets = overviewResponseModelAsJSON['Budget'];
  final convertedBudgets = List<Budget>.from(responseBudgets
          ?.map<dynamic>((dynamic model) => BudgetModel.fromJSON(model)) ??
      <Budget>[]);

  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  final responseCategories = overviewResponseModelAsJSON['Category'];
  final convertedCategories = List<Category>.from(responseCategories
          ?.map<dynamic>((dynamic model) => CategoryModel.fromJSON(model)) ??
      <Category>[]);

  final responseWallet = overviewResponseModelAsJSON['Wallet'];
  Wallet? convertedWallet;

  /// Check if the response is a string or a list
  ///
  /// If string then convert them into a wallet
  /// If List then convert them into list of wallets and take the first wallet.
  if (responseWallet is Map) {
    convertedWallet =
        WalletModel.fromJSON(responseWallet as Map<String, dynamic>);
  } else if (responseWallet is List) {
    final convertedWallets = List<Wallet>.from(responseWallet
        .map<dynamic>((dynamic model) => WalletModel.fromJSON(model)));

    convertedWallet = convertedWallets[0];
  }
  return OverviewResponseModel(
      transactions: convertedTransactions,
      budgets: convertedBudgets,
      categories: convertedCategories,
      wallet: convertedWallet);
}
