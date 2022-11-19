import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/wallet_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late WalletRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = WalletRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to fetch all wallets', () {
    test('Should fetch all wallets with wallet id', () async {
      final fetchWalletAsString =
          fixture('responses/dashboard/wallet/fetch_wallet_info.json');
      final fetchWalletAsJSON = jsonDecode(fetchWalletAsString);
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final defaultWallet = fetchWalletAsJSON[0]['sk'];
      final contentBody = <String, dynamic>{
        'starts_with_date': startsWithDate,
        'ends_with_date': endsWithDate,
        'pk': defaultWallet
      };
      // arrange
      when(() => mockHTTPClientImpl!.post(constants.walletURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchWalletAsJSON);
      // act
      final wallet = await dataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet);
      // assert
      verify(() => mockHTTPClientImpl!.post(constants.walletURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(
          wallet.wallets!.first.walletId, equals(fetchWalletAsJSON[0]['sk']));
      expect(wallet.wallets!.first.userId, equals(fetchWalletAsJSON[0]['pk']));
    });
  });

  group('Attempt to add a wallet', () {
    test(
      'Should add a wallet',
      () async {
        final addWalletAsString =
            fixture('responses/dashboard/wallet/add_wallet_info.json');
        final addWalletAsJSON = jsonDecode(addWalletAsString);
        final userId = addWalletAsJSON['body-json']['userId'];
        final currency = addWalletAsJSON['body-json']['currency'];
        final name = addWalletAsJSON['body-json']['walletName'];
        final contentBody = <String, dynamic>{
          'pk': userId,
          'wallet_currency': currency,
          'wallet_name': name,
        };
        // arrange
        when(() => mockHTTPClientImpl!.put(constants.walletURL,
                body: jsonEncode(contentBody), headers: constants.headers))
            .thenAnswer((_) async => addWalletAsJSON);
        // act
        await dataSource.add(userId: userId, currency: currency, name: name);
        // assert
        verify(() => mockHTTPClientImpl!.put(constants.walletURL,
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
            jsonDecode(updateWalletCurrencyAsString);
        final wallet = WalletModel(
            walletId: updateWalletCurrencyAsJSON['body-json']['pk'],
            userId: updateWalletCurrencyAsJSON['body-json']['pk'],
            currency: updateWalletCurrencyAsJSON['body-json']['currency']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.walletURL,
                body: jsonEncode(wallet.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateWalletCurrencyAsJSON);
        // act
        await dataSource.update(wallet);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.walletURL,
            body: jsonEncode(wallet.toJSON()), headers: constants.headers));
      },
    );

    test(
      'Should update a wallets description',
      () async {
        final updateWalletNameAsString = fixture(
            'responses/dashboard/wallet/update/update_wallet_name_info.json');
        final updateWalletNameAsJSON = jsonDecode(updateWalletNameAsString);
        final wallet = WalletModel(
            walletId: updateWalletNameAsJSON['body-json']['pk'],
            userId: updateWalletNameAsJSON['body-json']['pk'],
            walletName: updateWalletNameAsJSON['body-json']['name']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.walletURL,
                body: jsonEncode(wallet.toJSON()), headers: constants.headers))
            .thenAnswer((_) async => updateWalletNameAsJSON);
        // act
        await dataSource.update(wallet);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.walletURL,
            body: jsonEncode(wallet.toJSON()), headers: constants.headers));
      },
    );
  });

  group('Attempt to delete a wallet item', () {
    final deleteWalletResponseAsString =
        fixture('responses/dashboard/wallet/delete_wallet_info.json');
    final deleteWalletResponseAsJSON = jsonDecode(deleteWalletResponseAsString);
    const walletId = 'Wallet#2020-12-21T20:35:49.295Z';
    const userId = 'User#2021-01-04T15:20:36.079Z';
    test(
      'Should delete the appropriate wallet item when invoked',
      () async {
        // arrange
        when(() => mockHTTPClientImpl!.post(constants.walletURL,
                body: jsonEncode({
                  'pk': walletId,
                  'deleteAccount': false,
                  'referenceNumber': userId
                }),
                headers: constants.headers))
            .thenAnswer((_) async => deleteWalletResponseAsJSON);
        // act
        await dataSource.delete(walletId: walletId, userId: userId);
        // assert
        verify(() => mockHTTPClientImpl!.post(constants.walletURL,
            body: jsonEncode({
              'pk': walletId,
              'deleteAccount': false,
              'referenceNumber': userId
            }),
            headers: constants.headers));
      },
    );
  });
}
