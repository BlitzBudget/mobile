import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/network/network_helper.dart';
import 'package:mobile_blitzbudget/core/network/network_info.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockHttpClient mockHttpClient;
  late NetworkHelper networkHelper;
  late MockNetworkInfo mockNetworkInfo;
  final addBudgetAsString =
      fixture('responses/dashboard/budget/add_budget_info.json');

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockNetworkInfo = MockNetworkInfo();
    networkHelper =
        NetworkHelper(networkInfo: mockNetworkInfo, httpClient: mockHttpClient);
  });

  group('Validate HTTP POST', () {
    test('Should make a valid http call and receive a mock response', () async {
      when(() => mockHttpClient.post(Uri.parse(constants.budgetURL),
              body: jsonEncode(''), headers: constants.headers))
          .thenAnswer(
              (_) => Future.value(http.Response(addBudgetAsString, 200)));
      // Mock Network Call then return
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) => Future.value(true));
      // Network Helper
      await networkHelper.post(constants.budgetURL,
          body: jsonEncode(''), headers: constants.headers);

      verify(() => mockHttpClient.post(Uri.parse(constants.budgetURL),
          body: jsonEncode(''), headers: constants.headers));
    });

    test(
      'NoNetworkConnectionException',
      () async {
        when(() => mockHttpClient.post(Uri.parse(constants.budgetURL),
                body: jsonEncode(''), headers: constants.headers))
            .thenAnswer(
                (_) => Future.value(http.Response(addBudgetAsString, 200)));

        /// Throw 401 Error
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) async => Future.value(false));

        // assert
        expect(
            () => networkHelper.post(constants.budgetURL,
                body: jsonEncode(''), headers: constants.headers),
            throwsA(const TypeMatcher<NoNetworkConnectionException>()));
        // Verify network info is connected
        verify(() => mockNetworkInfo.isConnected);
        // Verify network helper was not called
        verifyNever(() => mockHttpClient.post(Uri.parse(constants.budgetURL),
            headers: constants.headers));
      },
    );
  });

  group('Validate HTTP PATCH', () {
    test('Should make a valid http call and receive a mock response', () async {
      when(() => mockHttpClient.patch(Uri.parse(constants.budgetURL),
              body: jsonEncode(''), headers: constants.headers))
          .thenAnswer(
              (_) => Future.value(http.Response(addBudgetAsString, 200)));
      // Mock Network Call then return
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) => Future.value(true));
      // Network Helper
      await networkHelper.patch(constants.budgetURL,
          body: jsonEncode(''), headers: constants.headers);

      verify(() => mockHttpClient.patch(Uri.parse(constants.budgetURL),
          body: jsonEncode(''), headers: constants.headers));
    });

    test(
      'NoNetworkConnectionException',
      () async {
        when(() => mockHttpClient.patch(Uri.parse(constants.budgetURL),
                body: jsonEncode(''), headers: constants.headers))
            .thenAnswer(
                (_) => Future.value(http.Response(addBudgetAsString, 200)));

        /// Throw 401 Error
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) async => Future.value(false));

        // assert
        expect(
            () => networkHelper.patch(constants.budgetURL,
                body: jsonEncode(''), headers: constants.headers),
            throwsA(const TypeMatcher<NoNetworkConnectionException>()));
        // Verify network info is connected
        verify(() => mockNetworkInfo.isConnected);
        // Verify network helper was not called
        verifyNever(() => mockHttpClient.patch(Uri.parse(constants.budgetURL),
            headers: constants.headers));
      },
    );
  });

  group('Validate HTTP PUT', () {
    test('Should make a valid http call and receive a mock response', () async {
      when(() => mockHttpClient.put(Uri.parse(constants.budgetURL),
              body: jsonEncode(''), headers: constants.headers))
          .thenAnswer(
              (_) => Future.value(http.Response(addBudgetAsString, 200)));

      // Mock Network Call then return
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) => Future.value(true));
      // Network Helper
      await networkHelper.put(constants.budgetURL,
          body: jsonEncode(''), headers: constants.headers);

      verify(() => mockHttpClient.put(Uri.parse(constants.budgetURL),
          body: jsonEncode(''), headers: constants.headers));
    });

    test(
      'NoNetworkConnectionException',
      () async {
        when(() => mockHttpClient.put(Uri.parse(constants.budgetURL),
                body: jsonEncode(''), headers: constants.headers))
            .thenAnswer(
                (_) => Future.value(http.Response(addBudgetAsString, 200)));

        /// Throw 401 Error
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) async => Future.value(false));

        // assert
        expect(
            () => networkHelper.put(constants.budgetURL,
                body: jsonEncode(''), headers: constants.headers),
            throwsA(const TypeMatcher<NoNetworkConnectionException>()));
        // Verify network info is connected
        verify(() => mockNetworkInfo.isConnected);
        // Verify network helper was not called
        verifyNever(() => mockHttpClient.put(Uri.parse(constants.budgetURL),
            headers: constants.headers));
      },
    );
  });
}
