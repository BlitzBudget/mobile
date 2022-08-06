import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/transaction/transaction_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/transaction/transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late TransactionRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource =
        TransactionRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to fetch all transactions', () {
    test('Should fetch all transactions with wallet id', () async {
      final fetchTransactionAsString = fixture(
          'responses/dashboard/transaction/fetch_transaction_info.json');
      final fetchTransactionAsJSON = jsonDecode(fetchTransactionAsString);
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final defaultWallet = fetchTransactionAsJSON[0]['sk'];
      final contentBody = <String, dynamic>{
        'starts_with_date': startsWithDate,
        'ends_with_date': endsWithDate,
        'wallet_id': defaultWallet
      };
      // arrange
      when(() => mockHTTPClientImpl!.post(constants.transactionURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchTransactionAsJSON);
      // act
      final transactions = await dataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet);
      // assert
      verify(() => mockHTTPClientImpl!.post(constants.transactionURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(
        transactions.transactions != null,
        equals(true),
      );
    });
  });
  group('Attempt to add a transaction', () {
    test(
      'Should add a transaction',
      () async {
        final addTransactionAsString = fixture(
            'responses/dashboard/transaction/add_transaction_info.json');
        final addTransactionAsJSON = jsonDecode(addTransactionAsString);
        final tags = (addTransactionAsJSON['body-json']['tags'])
            ?.map<String>(parseDynamicAsString)
            ?.toList();
        final transaction = TransactionModel(
            walletId: addTransactionAsJSON['body-json']['pk'],
            transactionId: addTransactionAsJSON['body-json']['transactionId'],
            amount: parseDynamicAsDouble(
                addTransactionAsJSON['body-json']['amount']),
            description: addTransactionAsJSON['body-json']['description'],
            tags: tags);
        // arrange
        when(() => mockHTTPClientImpl!.put(constants.transactionURL,
                body: jsonEncode(transaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => addTransactionAsJSON);
        // act
        await dataSource.add(transaction);
        // assert
        verify(() => mockHTTPClientImpl!.put(constants.transactionURL,
            body: jsonEncode(transaction.toJSON()),
            headers: constants.headers));
      },
    );
  });

  group('Attempt to update a transaction', () {
    test(
      'Should update a transactions amount',
      () async {
        final updateAmountAsString = fixture(
            'responses/dashboard/transaction/update/update_transaction_amount_info.json');
        final updateAmountAsJSON = jsonDecode(updateAmountAsString);
        final transaction = TransactionModel(
            walletId: updateAmountAsJSON['body-json']['pk'],
            transactionId: updateAmountAsJSON['body-json']['transactionId'],
            amount: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['amount']));
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.transactionURL,
                body: jsonEncode(transaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(transaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.transactionURL,
            body: jsonEncode(transaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a transactions description',
      () async {
        final updateDescriptionAsString = fixture(
            'responses/dashboard/transaction/update/update_transaction_description_info.json');
        final updateDescriptionAsJSON = jsonDecode(updateDescriptionAsString);
        final transaction = TransactionModel(
            walletId: updateDescriptionAsJSON['body-json']['pk'],
            transactionId: updateDescriptionAsJSON['body-json']
                ['transactionId'],
            description: updateDescriptionAsJSON['body-json']['description']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.transactionURL,
                body: jsonEncode(transaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateDescriptionAsJSON);
        // act
        await dataSource.update(transaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.transactionURL,
            body: jsonEncode(transaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a transactions tags',
      () async {
        final updateTagsAsString = fixture(
            'responses/dashboard/transaction/update/update_transaction_tags_info.json');
        final updateTagsAsJSON = jsonDecode(updateTagsAsString);
        final tags = (updateTagsAsJSON['body-json']['tags'])
            ?.map<String>(parseDynamicAsString)
            ?.toList();
        final transaction = TransactionModel(
            walletId: updateTagsAsJSON['body-json']['pk'],
            transactionId: updateTagsAsJSON['body-json']['transactionId'],
            tags: tags);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.transactionURL,
                body: jsonEncode(transaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateTagsAsJSON);
        // act
        await dataSource.update(transaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.transactionURL,
            body: jsonEncode(transaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a transactions category',
      () async {
        final updateCategoryAsString = fixture(
            'responses/dashboard/transaction/update/update_transaction_category_info.json');
        final updateCategoryAsJSON = jsonDecode(updateCategoryAsString);
        final transaction = TransactionModel(
            walletId: updateCategoryAsJSON['body-json']['pk'],
            transactionId: updateCategoryAsJSON['body-json']['transactionId'],
            categoryId: updateCategoryAsJSON['body-json']['category']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.transactionURL,
                body: jsonEncode(transaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateCategoryAsJSON);
        // act
        await dataSource.update(transaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.transactionURL,
            body: jsonEncode(transaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a transactions account',
      () async {
        final updateAccountAsString = fixture(
            'responses/dashboard/transaction/update/update_transaction_account_info.json');
        final updateAccountAsJSON = jsonDecode(updateAccountAsString);
        final transaction = TransactionModel(
            walletId: updateAccountAsJSON['body-json']['pk'],
            transactionId: updateAccountAsJSON['body-json']['transactionId'],
            categoryId: updateAccountAsJSON['body-json']['category']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.transactionURL,
                body: jsonEncode(transaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateAccountAsJSON);
        // act
        await dataSource.update(transaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(constants.transactionURL,
            body: jsonEncode(transaction.toJSON()),
            headers: constants.headers));
      },
    );
  });
}
