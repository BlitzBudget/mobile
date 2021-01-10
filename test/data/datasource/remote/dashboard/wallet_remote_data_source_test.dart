import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/wallet_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  WalletRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = WalletRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to add a wallet', () {
    test(
      'Should add a wallet',
      () async {
        final addWalletAsString =
            fixture('responses/dashboard/wallet/add_wallet_info.json');
        final addWalletAsJSON =
            jsonDecode(addWalletAsString) as Map<String, dynamic>;
        final userId = addWalletAsJSON['body-json']['userId'] as String;
        final currency = addWalletAsJSON['body-json']['currency'] as String;
        final contentBody = <String, dynamic>{
          'userId': userId,
          'currency': currency,
        };
        // arrange
        when(mockHTTPClientImpl.put(constants.walletURL,
                body: jsonEncode(contentBody), headers: constants.headers))
            .thenAnswer((_) async => addWalletAsJSON);
        // act
        await dataSource.add(userId: userId, currency: currency);
        ;
        // assert
        verify(mockHTTPClientImpl.put(constants.walletURL,
            body: jsonEncode(contentBody), headers: constants.headers));
      },
    );
  });

  group('Attempt to update a wallet', () {
    test(
      'Should update a wallets amount',
      () async {
        final updateWalletCurrencyAsString = fixture(
            'responses/dashboard/wallet/update/update_wallet_currency_info.json');
        final updateWalletCurrencyAsJSON =
            jsonDecode(updateWalletCurrencyAsString) as Map<String, dynamic>;
        final wallet = WalletModel(
            walletId:
                updateWalletCurrencyAsJSON['body-json']['walletId'] as String,
            userId:
                updateWalletCurrencyAsJSON['body-json']['walletId'] as String,
            currency:
                updateWalletCurrencyAsJSON['body-json']['currency'] as String);
        // arrange
        when(mockHTTPClientImpl.patch(constants.walletURL,
                body: jsonEncode(wallet.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateWalletCurrencyAsJSON);
        // act
        await dataSource.update(wallet);
        // assert
        verify(mockHTTPClientImpl.patch(constants.walletURL,
            body: jsonEncode(wallet.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a wallets description',
      () async {
        final updateWalletNameAsString = fixture(
            'responses/dashboard/wallet/update/update_wallet_name_info.json');
        final updateWalletNameAsJSON =
            jsonDecode(updateWalletNameAsString) as Map<String, dynamic>;
        final wallet = WalletModel(
            walletId: updateWalletNameAsJSON['body-json']['walletId'] as String,
            userId: updateWalletNameAsJSON['body-json']['walletId'] as String,
            walletName: updateWalletNameAsJSON['body-json']['name'] as String);
        // arrange
        when(mockHTTPClientImpl.patch(constants.walletURL,
                body: jsonEncode(wallet.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateWalletNameAsJSON);
        // act
        await dataSource.update(wallet);
        // assert
        verify(mockHTTPClientImpl.patch(constants.walletURL,
            body: jsonEncode(wallet.toJSON()), headers: constants.headers));
      },
    );
  });

  group('Attempt to delete a wallet item', () {
    final deleteWalletResponseAsString =
        fixture('responses/dashboard/wallet/delete_wallet_info.json');
    final deleteWalletResponseAsJSON =
        jsonDecode(deleteWalletResponseAsString) as Map<String, dynamic>;
    final walletId = 'Wallet#2020-12-21T20:35:49.295Z';
    final userId = 'User#2021-01-04T15:20:36.079Z';
    test(
      'Should delete the appropriate wallet item when invoked',
      () async {
        // arrange
        when(mockHTTPClientImpl.post(constants.walletURL,
                body: jsonEncode({
                  'walletId': walletId,
                  'deleteAccount': false,
                  'referenceNumber': userId
                }),
                headers: constants.headers))
            .thenAnswer((_) async => deleteWalletResponseAsJSON);
        // act
        await dataSource.delete(walletId: walletId, userId: userId);
        // assert
        verify(mockHTTPClientImpl.post(constants.walletURL,
            body: jsonEncode({
              'walletId': walletId,
              'deleteAccount': false,
              'referenceNumber': userId
            }),
            headers: constants.headers));
      },
    );
  });
}
