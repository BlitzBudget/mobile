import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/overview_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  late OverviewRemoteDataSourceImpl dataSource;
  HTTPClientImpl? mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = OverviewRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to fetch overview data', () {
    test('Should fetch all data for overview with wallet id', () async {
      final fetchOverviewAsString =
          fixture('responses/dashboard/overview_info.json');
      final fetchOverviewAsJSON = jsonDecode(fetchOverviewAsString);
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final defaultWallet = fetchOverviewAsJSON['Transaction'][0]['pk'];
      final contentBody = <String, dynamic>{
        'starts_with_date': startsWithDate,
        'ends_with_date': endsWithDate,
        'pk': defaultWallet
      };
      // arrange
      when(() => mockHTTPClientImpl!.post(constants.overviewURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchOverviewAsJSON);
      // act
      final overviewResponse = await dataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet);
      // assert
      verify(() => mockHTTPClientImpl!.post(constants.overviewURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(overviewResponse.transactions!.last.transactionId,
          equals(fetchOverviewAsJSON['Transaction'][0]['sk']));
    });
  });
}
