import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/dashboard/overview_remote_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  OverviewRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource = OverviewRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to fetch overview data', () {
    test('Should fetch all data for overview with wallet id', () async {
      final fetchOverviewAsString =
          fixture('responses/dashboard/overview_info.json');
      final fetchOverviewAsJSON =
          jsonDecode(fetchOverviewAsString) as Map<String, dynamic>;
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final defaultWallet =
          fetchOverviewAsJSON['BankAccount'][0]['walletId'] as String;
      String userId;
      final contentBody = <String, dynamic>{
        'startsWithDate': startsWithDate,
        'endsWithDate': endsWithDate,
        'walletId': defaultWallet
      };
      // arrange
      when(mockHTTPClientImpl.post(constants.overviewURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchOverviewAsJSON);
      // act
      var overviewResponse = await dataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet,
          userId: userId);
      // assert
      verify(mockHTTPClientImpl.post(constants.overviewURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(overviewResponse.dates.last.dateId,
          equals(fetchOverviewAsJSON['Date'][0]['dateId'] as String));
      expect(overviewResponse.bankAccounts.last.accountId,
          equals(fetchOverviewAsJSON['BankAccount'][0]['accountId'] as String));
    });

    test('Should fetch all data for overview with user Id', () async {
      final fetchOverviewAsString =
          fixture('responses/dashboard/overview_info.json');
      final fetchOverviewAsJSON =
          jsonDecode(fetchOverviewAsString) as Map<String, dynamic>;
      final startsWithDate = DateTime.now().toIso8601String();
      final endsWithDate = startsWithDate;
      final userId =
          fetchOverviewAsJSON['BankAccount'][0]['walletId'] as String;
      String defaultWallet;
      final contentBody = <String, dynamic>{
        'startsWithDate': startsWithDate,
        'endsWithDate': endsWithDate,
        'userId': userId
      };
      // arrange
      when(mockHTTPClientImpl.post(constants.overviewURL,
              body: jsonEncode(contentBody), headers: constants.headers))
          .thenAnswer((_) async => fetchOverviewAsJSON);
      // act
      var overviewResponse = await dataSource.fetch(
          startsWithDate: startsWithDate,
          endsWithDate: endsWithDate,
          defaultWallet: defaultWallet,
          userId: userId);
      // assert
      verify(mockHTTPClientImpl.post(constants.overviewURL,
          body: jsonEncode(contentBody), headers: constants.headers));

      expect(overviewResponse.dates.last.dateId,
          equals(fetchOverviewAsJSON['Date'][0]['dateId'] as String));
      expect(overviewResponse.bankAccounts.last.accountId,
          equals(fetchOverviewAsJSON['BankAccount'][0]['accountId'] as String));
    });
  });
}
