import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  test(
    'Should be a subclass of BankAccount entity',
    () async {
      final bankAccountModel = BankAccountModel();
      // assert
      expect(bankAccountModel, isA<BankAccount>());
    },
  );

  group('fromJson', () {
    test('should return a valid model when the JSON is parsed with all data',
        () async {
      final bankAccountModelAsString =
          fixture('models/bank-account/bank_account_model.json');
      final bankAccountModelAsJSON =
          jsonDecode(bankAccountModelAsString) as Map<String, dynamic>;
      final bankAccountModel = BankAccountModel(
          walletId: bankAccountModelAsJSON['walletId'] as String,
          accountId: bankAccountModelAsJSON['accountId'] as String,
          accountBalance:
              parseDynamicAsDouble(bankAccountModelAsJSON['account_balance']),
          bankAccountName:
              bankAccountModelAsJSON['bank_account_name'] as String,
          accountType: BankAccountModel.parseDynamicAsAccountType(
              bankAccountModelAsJSON['accountType']),
          selectedAccount: bankAccountModelAsJSON['selected_account'] as bool,
          linked: bankAccountModelAsJSON['linked'] as bool);
      final bankAccountModelConverted =
          BankAccountModel.fromJSON(bankAccountModelAsJSON);
      expect(bankAccountModel, equals(bankAccountModelConverted));
    });
  });
}
