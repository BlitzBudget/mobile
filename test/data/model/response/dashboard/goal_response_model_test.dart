import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/model/date_model.dart';
import 'package:mobile_blitzbudget/data/model/goal/goal_model.dart';
import 'package:mobile_blitzbudget/data/model/response/dashboard/goal_response_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';
import 'package:mobile_blitzbudget/domain/entities/date.dart';
import 'package:mobile_blitzbudget/domain/entities/goal/goal.dart';
import 'package:mobile_blitzbudget/domain/entities/response/goal_response.dart';
import 'package:mobile_blitzbudget/domain/entities/wallet/wallet.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final goalResponseModelAsString =
      fixture('responses/dashboard/goal/fetch_goal_info.json');
  final goalResponseModelAsJSON =
      jsonDecode(goalResponseModelAsString) as Map<String, dynamic>;

  /// Convert goals from the response JSON to List<Goal>
  /// If Empty then return an empty object list
  var goalResponseModel = convertToResponseModel(goalResponseModelAsJSON);

  test(
    'Should be a subclass of GoalModel entity',
    () async {
      // assert
      expect(goalResponseModel, isA<GoalResponse>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final goalModelConverted =
          GoalResponseModel.fromJSON(goalResponseModelAsJSON);
      expect(goalModelConverted, equals(goalResponseModel));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty bank account data',
        () async {
      final goalResponseModelWithEmptyBankAccountAsString = fixture(
          'responses/partially-emtpy/goal/empty_bank_account_goal_info.json');
      final goalResponseModelWithEmptyBankAccountAsJSON =
          jsonDecode(goalResponseModelWithEmptyBankAccountAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyBankAccountConverted =
          convertToResponseModel(goalResponseModelWithEmptyBankAccountAsJSON);
      final goalResponseModelWithEmptyBankAccountFromJSON =
          GoalResponseModel.fromJSON(
              goalResponseModelWithEmptyBankAccountAsJSON);
      expect(goalResponseModelWithEmptyBankAccountFromJSON,
          equals(goalResponseModelWithEmptyBankAccountConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty date data',
        () async {
      final goalResponseModelWithEmptyDateAsString =
          fixture('responses/partially-emtpy/goal/empty_date_goal_info.json');
      final goalResponseModelWithEmptyDateAsJSON =
          jsonDecode(goalResponseModelWithEmptyDateAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyDateConverted =
          convertToResponseModel(goalResponseModelWithEmptyDateAsJSON);
      final goalResponseModelWithEmptyDateFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithEmptyDateAsJSON);
      expect(goalResponseModelWithEmptyDateFromJSON,
          equals(goalResponseModelWithEmptyDateConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty goal data',
        () async {
      final goalResponseModelWithEmptyGoalAsString =
          fixture('responses/partially-emtpy/goal/empty_goal_goal_info.json');
      final goalResponseModelWithEmptyGoalAsJSON =
          jsonDecode(goalResponseModelWithEmptyGoalAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyGoalConverted =
          convertToResponseModel(goalResponseModelWithEmptyGoalAsJSON);
      final goalResponseModelWithEmptyGoalFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithEmptyGoalAsJSON);
      expect(goalResponseModelWithEmptyGoalFromJSON,
          equals(goalResponseModelWithEmptyGoalConverted));
    });

    test(
        'Should return a valid model when the JSON is parsed with empty wallet data',
        () async {
      final goalResponseModelWithEmptyWalletAsString =
          fixture('responses/partially-emtpy/goal/empty_wallet_goal_info.json');
      final goalResponseModelWithEmptyWalletAsJSON =
          jsonDecode(goalResponseModelWithEmptyWalletAsString)
              as Map<String, dynamic>;

      /// Convert budgets from the response JSON to List<Budget>
      /// If Empty then return an empty object list
      final goalResponseModelWithEmptyWalletConverted =
          convertToResponseModel(goalResponseModelWithEmptyWalletAsJSON);
      final goalResponseModelWithEmptyWalletFromJSON =
          GoalResponseModel.fromJSON(goalResponseModelWithEmptyWalletAsJSON);
      expect(goalResponseModelWithEmptyWalletFromJSON,
          equals(goalResponseModelWithEmptyWalletConverted));
    });
  });
}

GoalResponseModel convertToResponseModel(
    Map<String, dynamic> goalResponseModelAsJSON) {
  /// Convert categories from the response JSON to List<Category>
  /// If Empty then return an empty object list
  var responseGoals = goalResponseModelAsJSON['Goal'] as List;
  var convertedGoals = List<Goal>.from(responseGoals?.map<dynamic>(
          (dynamic model) =>
              GoalModel.fromJSON(model as Map<String, dynamic>)) ??
      <Goal>[]);

  /// Convert BankAccount from the response JSON to List<BankAccount>
  /// If Empty then return an empty object list
  var responseBankAccounts = goalResponseModelAsJSON['BankAccount'] as List;
  var convertedBankAccounts = List<BankAccount>.from(
      responseBankAccounts?.map<dynamic>((dynamic model) =>
              BankAccountModel.fromJSON(model as Map<String, dynamic>)) ??
          <BankAccount>[]);

  /// Convert Dates from the response JSON to List<Date>
  /// If Empty then return an empty object list
  var responseDate = goalResponseModelAsJSON['Date'] as List;
  var convertedDates = List<Date>.from(responseDate?.map<dynamic>(
          (dynamic model) =>
              DateModel.fromJSON(model as Map<String, dynamic>)) ??
      <Date>[]);

  dynamic responseWallet = goalResponseModelAsJSON['Wallet'];
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
  return GoalResponseModel(
      goals: convertedGoals,
      bankAccounts: convertedBankAccounts,
      dates: convertedDates,
      wallet: convertedWallet);
}
