import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/transaction/recurring_transaction_remote_data_source.dart';
import 'package:mobile_blitzbudget/data/model/recurring-transaction/recurring_transaction_model.dart';
import 'package:mobile_blitzbudget/data/utils/data_utils.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  RecurringTransactionRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;

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
        final updateAmountAsJSON =
            jsonDecode(updateAmountAsString) as Map<String, dynamic>;
        final recurTransaction = RecurringTransactionModel(
            walletId: updateAmountAsJSON['body-json']['walletId'] as String,
            recurringTransactionId: updateAmountAsJSON['body-json']
                ['recurringTransactionId'] as String,
            amount: parseDynamicAsDouble(
                updateAmountAsJSON['body-json']['amount']));
        // arrange
        when(mockHTTPClientImpl.patch(constants.recurringTransactionURL,
                body: jsonEncode(recurTransaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateAmountAsJSON);
        // act
        await dataSource.update(recurTransaction);
        // assert
        verify(mockHTTPClientImpl.patch(constants.recurringTransactionURL,
            body: jsonEncode(recurTransaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a recurring transactions description',
      () async {
        final updateDescriptionAsString = fixture(
            'responses/dashboard/recurring-transaction/update_recurring_transaction_description_info.json');
        final updateDescriptionAsJSON =
            jsonDecode(updateDescriptionAsString) as Map<String, dynamic>;
        final recurTransaction = RecurringTransactionModel(
            walletId:
                updateDescriptionAsJSON['body-json']['walletId'] as String,
            recurringTransactionId: updateDescriptionAsJSON['body-json']
                ['recurringTransactionId'] as String,
            description:
                updateDescriptionAsJSON['body-json']['description'] as String);
        // arrange
        when(mockHTTPClientImpl.patch(constants.recurringTransactionURL,
                body: jsonEncode(recurTransaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateDescriptionAsJSON);
        // act
        await dataSource.update(recurTransaction);
        // assert
        verify(mockHTTPClientImpl.patch(constants.recurringTransactionURL,
            body: jsonEncode(recurTransaction.toJSON()),
            headers: constants.headers));
      },
    );

    test(
      'Should update a recurring transactions tags',
      () async {
        final updateTagsAsString = fixture(
            'responses/dashboard/recurring-transaction/update_recurring_transaction_tags_info.json');
        final updateTagsAsJSON =
            jsonDecode(updateTagsAsString) as Map<String, dynamic>;
        final tags = (updateTagsAsJSON['body-json']['tags'] as List)
            ?.map((dynamic item) => item as String)
            ?.toList();
        final recurTransaction = RecurringTransactionModel(
            walletId: updateTagsAsJSON['body-json']['walletId'] as String,
            recurringTransactionId: updateTagsAsJSON['body-json']
                ['recurringTransactionId'] as String,
            tags: tags);
        // arrange
        when(mockHTTPClientImpl.patch(constants.recurringTransactionURL,
                body: jsonEncode(recurTransaction.toJSON()),
                headers: constants.headers))
            .thenAnswer((_) async => updateTagsAsJSON);
        // act
        await dataSource.update(recurTransaction);
        // assert
        verify(mockHTTPClientImpl.patch(constants.recurringTransactionURL,
            body: jsonEncode(recurTransaction.toJSON()),
            headers: constants.headers));
      },
    );
  });
}
