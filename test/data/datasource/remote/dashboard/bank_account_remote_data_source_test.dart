import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/bank_account_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/bank-account/bank_account_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late BankAccountRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

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
        final addBankAccountAsJSON = jsonDecode(addBankAccountAsString);
        final bankAccount = BankAccountModel(
            walletId: addBankAccountAsJSON['body-json']['walletId'],
            accountId: addBankAccountAsJSON['body-json']['accountId'],
            linked: addBankAccountAsJSON['body-json']['linked'],
            selectedAccount: addBankAccountAsJSON['body-json']
                ['selectedAccount'],
            accountType: parseDynamicAsAccountType(
                addBankAccountAsJSON['body-json']['accountType']),
            accountSubType: parseDynamicAsAccountSubType(
                addBankAccountAsJSON['body-json']['accountSubType']),
            bankAccountName: addBankAccountAsJSON['body-json']
                ['bankAccountName']);
        // arrange
        when(() => mockHTTPClientImpl!.put(constants.bankAccountURL,
                body: jsonEncode(bankAccount.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => addBankAccountAsJSON);
        // act
        await dataSource.add(bankAccount);
        // assert
        verify(() => mockHTTPClientImpl!.put(constants.bankAccountURL,
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
        final updateAmountAsJSON = jsonDecode(updateAmountAsString);
        final bankAccount = BankAccountModel(
            walletId: updateAmountAsJSON['body-json']['walletId'],
            accountId: updateAmountAsJSON['body-json']['bankAccountId'],
            accountBalance: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['accountBalance']));
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.bankAccountURL,
                body: jsonEncode(bankAccount.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(bankAccount);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.bankAccountURL,
            body: jsonEncode(bankAccount.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a bankAccounts description',
      () async {
        final updateDescriptionAsString = fixture(
            'responses/dashboard/bank-account/update/select_bank_account_info.json');
        final updateDescriptionAsJSON = jsonDecode(updateDescriptionAsString);
        final bankAccount = BankAccountModel(
            walletId: updateDescriptionAsJSON['body-json']['walletId'],
            accountId: updateDescriptionAsJSON['body-json']['bankAccountId'],
            selectedAccount: updateDescriptionAsJSON['body-json']
                ['selectedAccount']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.bankAccountURL,
                body: jsonEncode(bankAccount.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateDescriptionAsJSON);
        // act
        await dataSource.update(bankAccount);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.bankAccountURL,
            body: jsonEncode(bankAccount.toJSON()),
            headers: constants.headers));
      },
    );
  });

  group('Attempt to delete a bankAccounts item', () {
    final deleteAccountInfoResponseAsString = fixture(
        'responses/dashboard/bank-account/delete_bank_account_info.json');
    final deleteAccountResponseAsJSON =
        jsonDecode(deleteAccountInfoResponseAsString);
    const walletId = 'Wallet#2020-12-21T20:35:49.295Z';
    const account = 'BankAccount#2021-01-04T15:20:36.079Z';
    test(
      'Should delete the appropriate wallet item when invoked',
      () async {
        // arrange
        when(() => mockHTTPClientImpl!.post(constants.deleteBankAccountURL,
                body: jsonEncode({'walletId': walletId, 'account': account}),
                headers: constants.headers))
            .thenAnswer((_) async => deleteAccountResponseAsJSON);
        // act
        await dataSource.delete(walletId: walletId, account: account);
        // assert
        verify(() => mockHTTPClientImpl!.post(constants.deleteBankAccountURL,
            body: jsonEncode({'walletId': walletId, 'account': account}),
            headers: constants.headers));
      },
    );
  });
}
