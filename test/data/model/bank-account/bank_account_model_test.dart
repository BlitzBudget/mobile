import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mobile_blitzbudget/domain/entities/bank-account/bank_account.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final bankAccountModelAsString =
      fixture('models/get/bank-account/bank_account_model.json');
  final bankAccountModelAsJSON =
      jsonDecode(bankAccountModelAsString);
  final bankAccountModel = BankAccountModel(
      walletId: bankAccountModelAsJSON['walletId'],
      accountId: bankAccountModelAsJSON['accountId'],
      accountBalance:
          parseDynamicAsDouble(bankAccountModelAsJSON['account_balance']),
      bankAccountName: bankAccountModelAsJSON['bank_account_name'],
      accountType:
          parseDynamicAsAccountType(bankAccountModelAsJSON['account_type']),
      accountSubType: parseDynamicAsAccountSubType(
          bankAccountModelAsJSON['account_sub_type']),
      selectedAccount: bankAccountModelAsJSON['selected_account'],
      linked: bankAccountModelAsJSON['linked']);
  test(
    'Should be a subclass of BankAccount entity',
    () async {
      // assert
      expect(bankAccountModel, isA<BankAccount>());
    },
  );

  group('fromJson', () {
    test('Should return a valid model when the JSON is parsed with all data',
        () async {
      final bankAccountModelConverted =
          BankAccountModel.fromJSON(bankAccountModelAsJSON);
      expect(bankAccountModelConverted, equals(bankAccountModel));
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data', () async {
      final addBankAccountModelAsString =
          fixture('models/add/bank-account/bank_account_model.json');
      final addBankAccountModelAsJSON =
          jsonDecode(addBankAccountModelAsString);
      expect(bankAccountModel.toJSON(), equals(addBankAccountModelAsJSON));
    });
  });
}
