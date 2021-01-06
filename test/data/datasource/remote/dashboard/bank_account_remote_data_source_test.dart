import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/bank_account_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  BankAccountRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource =
        BankAccountRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to add a bankAccount', () {
    test(
      'Should add a bankAccount',
      () async {
        final addBankAccountAsString = fixture(
            'responses/dashboard/bank-account/add_bank_account_info.json');
        final addBankAccountAsJSON =
            jsonDecode(addBankAccountAsString) as Map<String, dynamic>;
        final bankAccount = BankAccountModel(
            walletId: addBankAccountAsJSON['body-json']['walletId'] as String,
            accountId: addBankAccountAsJSON['body-json']['accountId'] as String,
            linked: addBankAccountAsJSON['body-json']['linked'] as bool,
            selectedAccount:
                addBankAccountAsJSON['body-json']['selectedAccount'] as bool,
            accountType: BankAccountModel.parseDynamicAsAccountType(
                addBankAccountAsJSON['body-json']['accountType']),
            accountSubType: BankAccountModel.parseDynamicAsAccountSubType(
                addBankAccountAsJSON['body-json']['accountSubType']),
            bankAccountName:
                addBankAccountAsJSON['body-json']['bankAccountName'] as String);
        // arrange
        when(mockHTTPClientImpl.put(constants.bankAccountURL,
                body: jsonEncode(bankAccount.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => addBankAccountAsJSON);
        // act
        await dataSource.add(bankAccount);
        // assert
        verify(mockHTTPClientImpl.put(constants.bankAccountURL,
            body: jsonEncode(bankAccount.toJSON()),
            headers: constants.headers));
      },
    );
  });

  group('Attempt to update a bankAccount', () {
    test(
      'Should update a bankAccounts amount',
      () async {
        final updateAmountAsString = fixture(
            'responses/dashboard/bank-account/update/update_bank_account_balanace_info.json');
        final updateAmountAsJSON =
            jsonDecode(updateAmountAsString) as Map<String, dynamic>;
        final bankAccount = BankAccountModel(
            walletId: updateAmountAsJSON['body-json']['walletId'] as String,
            accountId:
                updateAmountAsJSON['body-json']['bankAccountId'] as String,
            accountBalance: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['accountBalance']));
        // arrange
        when(mockHTTPClientImpl.patch(constants.bankAccountURL,
                body: jsonEncode(bankAccount.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(bankAccount);
        // assert
        verify(mockHTTPClientImpl.patch(constants.bankAccountURL,
            body: jsonEncode(bankAccount.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a bankAccounts description',
      () async {
        final updateDescriptionAsString = fixture(
            'responses/dashboard/bank-account/update/select_bank_account_info.json');
        final updateDescriptionAsJSON =
            jsonDecode(updateDescriptionAsString) as Map<String, dynamic>;
        final bankAccount = BankAccountModel(
            walletId:
                updateDescriptionAsJSON['body-json']['walletId'] as String,
            accountId:
                updateDescriptionAsJSON['body-json']['bankAccountId'] as String,
            selectedAccount: updateDescriptionAsJSON['body-json']
                ['selectedAccount'] as bool);
        // arrange
        when(mockHTTPClientImpl.patch(constants.bankAccountURL,
                body: jsonEncode(bankAccount.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateDescriptionAsJSON);
        // act
        await dataSource.update(bankAccount);
        // assert
        verify(mockHTTPClientImpl.patch(constants.bankAccountURL,
            body: jsonEncode(bankAccount.toJSON()),
            headers: constants.headers));
      },
    );
  });
}
