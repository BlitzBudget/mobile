// ignore_for_file: null_argument_to_non_null_type

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/core/network/network_helper.dart';
import 'package:mobile_blitzbudget/core/network/refresh_token_helper.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/constants/constants.dart';
import 'package:mobile_blitzbudget/data/model/response/user_response_model.dart';
import 'package:mobile_blitzbudget/data/model/user_model.dart';
import 'package:mobile_blitzbudget/data/model/wallet/wallet_model.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/dashboard/common/clear_all_storage_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

class MockAuthTokenRepository extends Mock implements AuthTokenRepository {}

class MockClearAllStorageRepository extends Mock
    implements ClearAllStorageRepository {}

class MockNetworkHelper extends Mock implements NetworkHelper {}

class MockRefreshTokenRepository extends Mock
    implements RefreshTokenRepository {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockAccessTokenRepository mockAccessTokenRepository;
  late RefreshTokenHelper refreshTokenHelper;
  late MockAuthTokenRepository mockAuthTokenRepository;
  late MockClearAllStorageRepository mockClearAllStorageRepository;
  MockNetworkHelper mockNetworkHelper;
  late MockRefreshTokenRepository mockRefreshTokenRepository;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockAccessTokenRepository = MockAccessTokenRepository();
    mockAuthTokenRepository = MockAuthTokenRepository();
    mockNetworkHelper = MockNetworkHelper();
    mockRefreshTokenRepository = MockRefreshTokenRepository();
    mockClearAllStorageRepository = MockClearAllStorageRepository();
    mockHttpClient = MockHttpClient();
    refreshTokenHelper = RefreshTokenHelper(
        accessTokenRepository: mockAccessTokenRepository,
        authTokenRepository: mockAuthTokenRepository,
        clearAllStorageRepository: mockClearAllStorageRepository,
        networkHelper: mockNetworkHelper,
        refreshTokenRepository: mockRefreshTokenRepository,
        httpClient: mockHttpClient);
  });

  group('Refresh Token Exception Scenarios', () {
    Either<Failure, String?> refreshTokenMonad;
    test(
        'Should return clearStoreAndThrowException if unable to read refresh token',
        () async {
      // If refresh token is empty
      final Either<Failure, String> refreshTokenMonad =
          Left<Failure, String>(EmptyResponseFailure());
      const clearAllStorageResponse = Right<Failure, void>('');
      when(() => mockRefreshTokenRepository.readRefreshToken())
          .thenAnswer((_) => Future.value(refreshTokenMonad));
      when(() => mockClearAllStorageRepository.clearAllStorage())
          .thenAnswer((_) => Future.value(clearAllStorageResponse));
      // assert
      expect(() => refreshTokenHelper.refreshAuthToken(constants.headers, null),
          throwsA(const TypeMatcher<UnableToRefreshTokenException>()));

      verify(() => mockRefreshTokenRepository.readRefreshToken());
    });

    void setUpMockHttpClientError500() {
      final userModelAsString =
          fixture('responses/authentication/login_info.json');
      final userModelAsJSON = jsonDecode(userModelAsString);
      final userModel = UserResponseModel(
          accessToken: userModelAsJSON['AuthenticationResult']['AccessToken'],
          authenticationToken: userModelAsJSON['AuthenticationResult']
              ['IdToken'],
          refreshToken: userModelAsJSON['AuthenticationResult']['RefreshToken'],
          user: UserModel.fromJSON(userModelAsJSON['UserAttributes']),
          wallet: WalletModel.fromJSON(userModelAsJSON['Wallet'][0]));
      const clearAllStorageResponse = Right<Failure, void>('');
      refreshTokenMonad = Right<Failure, String?>(userModel.refreshToken);
      final refreshTokenFuture = Future.value(refreshTokenMonad);
      // MOck Network Call then return
      when(() => mockRefreshTokenRepository.readRefreshToken())
          .thenAnswer((_) => refreshTokenFuture);
      when(() => mockClearAllStorageRepository.clearAllStorage())
          .thenAnswer((_) => Future.value(clearAllStorageResponse));

      final refreshTokenResponseString =
          fixture('responses/authentication/refresh_token_info.json');

      when(() => mockHttpClient.post(Uri.parse(refreshTokenURL),
              body: jsonEncode(
                  {'refreshToken': refreshTokenMonad.getOrElse(() => '')}),
              headers: headers))
          .thenAnswer(
              (_) async => http.Response(refreshTokenResponseString, 500));
    }

    test(
        'Should return clearStoreAndThrowException if response of refresh token is not 200 - 299',
        () async {
      setUpMockHttpClientError500();
      // UserModel from Refresh Token Response
      final userModelAsString =
          fixture('responses/authentication/refresh_token_info.json');
      final userModelAsJSON = jsonDecode(userModelAsString);
      final userModel = UserResponseModel.fromJSON(userModelAsJSON);
      // assert
      expect(() => refreshTokenHelper.refreshAuthToken(constants.headers, null),
          throwsA(const TypeMatcher<UnableToRefreshTokenException>()));

      verify(() => mockRefreshTokenRepository.readRefreshToken());
      verifyNever(() => mockAuthTokenRepository.writeAuthToken(userModel));
      verifyNever(() => mockAccessTokenRepository.writeAccessToken(userModel));
    });
  });

  group('Refresh Token Success Scenarios', () {
    late Either<Failure, String?> refreshTokenMonad;

    void setUpMockHttpClientSuccess200() {
      final userModelAsString =
          fixture('responses/authentication/login_info.json');
      final userModelAsJSON = jsonDecode(userModelAsString);
      final userModel = UserResponseModel(
          accessToken: userModelAsJSON['AuthenticationResult']['AccessToken'],
          authenticationToken: userModelAsJSON['AuthenticationResult']
              ['IdToken'],
          refreshToken: userModelAsJSON['AuthenticationResult']['RefreshToken'],
          user: UserModel.fromJSON(userModelAsJSON['UserAttributes']),
          wallet: WalletModel.fromJSON(userModelAsJSON['Wallet'][0]));
      refreshTokenMonad = Right<Failure, String?>(userModel.refreshToken);
      final refreshTokenFuture = Future.value(refreshTokenMonad);
      // MOck Network Call then return
      when(() => mockRefreshTokenRepository.readRefreshToken())
          .thenAnswer((_) => refreshTokenFuture);
      when(() => mockClearAllStorageRepository.clearAllStorage())
          .thenAnswer((_) => Future.value());

      final refreshTokenResponseString =
          fixture('responses/authentication/refresh_token_info.json');

      when(() => mockHttpClient.post(Uri.parse(refreshTokenURL),
              body: jsonEncode(
                  {'refreshToken': refreshTokenMonad.getOrElse(() => '')}),
              headers: headers))
          .thenAnswer(
              (_) async => http.Response(refreshTokenResponseString, 200));
    }

    test('Should return HTTP 200 response', () async {
      setUpMockHttpClientSuccess200();
      // UserModel from Refresh Token Response
      final userModelAsString =
          fixture('responses/authentication/refresh_token_info.json');
      final userModelAsJSON = jsonDecode(userModelAsString);
      final userModel = UserResponseModel.fromJSON(userModelAsJSON);
      when(() => mockClearAllStorageRepository.clearAllStorage())
          .thenAnswer((_) => Future.value());
      when(() => mockAuthTokenRepository.writeAuthToken(userModel))
          .thenAnswer((_) => Future.value());
      when(() => mockAccessTokenRepository.writeAccessToken(userModel))
          .thenAnswer((_) => Future.value());

      // assert
      await refreshTokenHelper.refreshAuthToken(constants.headers, null);

      verify(() => mockRefreshTokenRepository.readRefreshToken());
      verify(() => mockHttpClient.post(Uri.parse(refreshTokenURL),
          body: jsonEncode(
              {'refreshToken': refreshTokenMonad.getOrElse(() => '')}),
          headers: headers));
      verify(() => mockAuthTokenRepository.writeAuthToken(userModel));
      verify(() => mockAccessTokenRepository.writeAccessToken(userModel));
      expect(constants.headers['Authorization'],
          equals(userModel.authenticationToken));
    });
  });
}
