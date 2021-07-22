import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/category_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late CategoryRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = CategoryRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to delete a category item', () {
    final deleteItemResponseAsString =
        fixture('responses/dashboard/common/delete_item_info.json');
    final deleteItemResponseAsJSON = jsonDecode(deleteItemResponseAsString);
    const walletId = 'Wallet#2020-12-21T20:35:49.295Z';
    const categoryId = 'Category#2021-01-04T15:20:36.079Z';
    test(
      'Should delete the appropriate category item when invoked',
      () async {
        // arrange
        when(() => mockHTTPClientImpl!.post(constants.deleteCategoryURL,
                body: jsonEncode({
                  'walletId': walletId,
                  'category': categoryId,
                }),
                headers: constants.headers))
            .thenAnswer((_) async => deleteItemResponseAsJSON);
        // act
        await dataSource.delete(walletId: walletId, category: categoryId);
        // assert
        verify(() => mockHTTPClientImpl!.post(constants.deleteCategoryURL,
            body: jsonEncode({
              'walletId': walletId,
              'category': categoryId,
            }),
            headers: constants.headers));
      },
    );
  });
}
