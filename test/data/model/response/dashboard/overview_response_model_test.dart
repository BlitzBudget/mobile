import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/budget/budget_model.dart';
import 'package:mobile_blitzbudget/data/model/category/category_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/overview_response_model.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/budget/budget.dart';
import 'package:mobile_blitzbudget/domain/entities/category/category.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/response/overview_response.dart';
import 'package:mobile_blitzbudget/domain/entities/transaction/transaction.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final overviewResponseModelAsString =
      fixture('responses/dashboard/overview/fetch_overview_info.json');
  final overviewResponseModelAsJSON =
      jsonDecode(overviewResponseModelAsString) as Map<String, dynamic>;

  /// Convert overviews from the response JSON to List<Overview>
  /// If Empty then return an empty object list
  var overviewResponseModel =
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
}

OverviewResponseModel convertToResponseModel(
    Map<String, dynamic> overviewResponseModelAsJSON) {
  /// Convert transactions from the response JSON to List<Transaction>
  /// If Empty then return an empty object list
  var responseTransactions = overviewResponseModelAsJSON['Transaction'] as List;
  var convertedTransactions = List<Transaction>.from(
      responseTransactions?.map<dynamic>((dynamic model) =>
              TransactionModel.fromJSON(model as Map<String, dynamic>)) ??
          <Transaction>[]);

  /// Convert budgets from the response JSON to List<Budget>
  /// If Empty then return an empty object list
  var responseBudgets = overviewResponseModelAsJSON['Budget'] as List;
  var convertedBudgets = List<Budget>.from(responseBudgets?.map<dynamic>(
          (dynamic model) =>
              BudgetModel.fromJSON(model as Map<String, dynamic>)) ??
      <Budget>[]);

  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  var responseCategories = overviewResponseModelAsJSON['Category'] as List;
  var convertedCategories = List<Category>.from(
      responseCategories?.map<dynamic>((dynamic model) =>
              CategoryModel.fromJSON(model as Map<String, dynamic>)) ??
          <Category>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  var responseBankAccounts = overviewResponseModelAsJSON['BankAccount'] as List;
  var convertedBankAccounts = List<BankAccount>.from(
      responseBankAccounts?.map<dynamic>((dynamic model) =>
              BankAccountModel.fromJSON(model as Map<String, dynamic>)) ??
          <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  var responseDate = overviewResponseModelAsJSON['Date'] as List;
  var convertedDates = List<Date>.from(responseDate?.map<dynamic>(
          (dynamic model) =>
              DateModel.fromJSON(model as Map<String, dynamic>)) ??
      <Date>[]);

  dynamic responseWallet = overviewResponseModelAsJSON['Wallet'];
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
  return OverviewResponseModel(
      transactions: convertedTransactions,
      budgets: convertedBudgets,
      categories: convertedCategories,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet);
}
