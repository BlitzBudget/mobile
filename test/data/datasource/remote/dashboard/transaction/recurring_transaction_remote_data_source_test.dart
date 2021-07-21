import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/transaction/recurring_transaction_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late RecurringTransactionRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = RecurringTransactionRemoteDataSourceImpl(
        httpClient: mockHTTPClientImpl);
  });

  group('Attempt to update a recurring transaction', () {
    test(
      'Should update a recurring transactions amount',
      () async {
        final updateAmountAsString = fixture(
            'responses/dashboard/recurring-transaction/update_recurring_transaction_amount_info.json');
        final updateAmountAsJSON = jsonDecode(updateAmountAsString);
        final recurTransaction = RecurringTransactionModel(
            walletId: updateAmountAsJSON['body-json']['walletId'],
            recurringTransactionId: updateAmountAsJSON['body-json']
                ['recurringTransactionId'],
            amount: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['amount']));
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.recurringTransactionURL,
                body: jsonEncode(recurTransaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(recurTransaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(
            constants.recurringTransactionURL,
            body: jsonEncode(recurTransaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a recurring transactions description',
      () async {
        final updateDescriptionAsString = fixture(
            'responses/dashboard/recurring-transaction/update_recurring_transaction_description_info.json');
        final updateDescriptionAsJSON = jsonDecode(updateDescriptionAsString);
        final recurTransaction = RecurringTransactionModel(
            walletId: updateDescriptionAsJSON['body-json']['walletId'],
            recurringTransactionId: updateDescriptionAsJSON['body-json']
                ['recurringTransactionId'],
            description: updateDescriptionAsJSON['body-json']['description']);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.recurringTransactionURL,
                body: jsonEncode(recurTransaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateDescriptionAsJSON);
        // act
        await dataSource.update(recurTransaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(
            constants.recurringTransactionURL,
            body: jsonEncode(recurTransaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a recurring transactions tags',
      () async {
        final updateTagsAsString = fixture(
            'responses/dashboard/recurring-transaction/update_recurring_transaction_tags_info.json');
        final updateTagsAsJSON = jsonDecode(updateTagsAsString);
        final tags = (updateTagsAsJSON['body-json']['tags'])
            ?.map<String>(parseDynamicAsString)
            ?.toList();
        final recurTransaction = RecurringTransactionModel(
            walletId: updateTagsAsJSON['body-json']['walletId'],
            recurringTransactionId: updateTagsAsJSON['body-json']
                ['recurringTransactionId'],
            tags: tags);
        // arrange
        when(() => mockHTTPClientImpl!.patch(constants.recurringTransactionURL,
                body: jsonEncode(recurTransaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateTagsAsJSON);
        // act
        await dataSource.update(recurTransaction);
        // assert
        verify(() => mockHTTPClientImpl!.patch(
            constants.recurringTransactionURL,
            body: jsonEncode(recurTransaction.toJSON()),
            headers: constants.headers));
      },
    );
  });
}
