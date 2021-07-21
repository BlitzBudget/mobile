import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_blitzbudget/core/failure/authorization_failure.dart';
import 'package:mobile_blitzbudget/core/failure/failure.dart';
import 'package:mobile_blitzbudget/core/failure/generic_failure.dart';
import 'package:mobile_blitzbudget/domain/entities/response/user_response.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/access_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/auth_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/authentication_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/refresh_token_repository.dart';
import 'package:mobile_blitzbudget/domain/repositories/authentication/user_attributes_repository.dart';
import 'package:mobile_blitzbudget/domain/usecases/authentication/login_user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

class MockAuthTokenRepository extends Mock implements AuthTokenRepository {}

class MockRefreshTokenRepository extends Mock
    implements RefreshTokenRepository {}

class MockUserAttributesRepository extends Mock
    implements UserAttributesRepository {}

void main() {
  MockAuthenticationRepository? mockAuthenticationRepository;
  MockAccessTokenRepository? mockAccessTokenRepository;
  MockAuthTokenRepository? mockAuthTokenRepository;
  MockRefreshTokenRepository? mockRefreshTokenRepository;
  MockUserAttributesRepository? mockUserAttributesRepository;
  late LoginUser loginUser;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockAccessTokenRepository = MockAccessTokenRepository();
    mockAuthTokenRepository = MockAuthTokenRepository();
    mockRefreshTokenRepository = MockRefreshTokenRepository();
    mockUserAttributesRepository = MockUserAttributesRepository();
    loginUser = LoginUser(
        accessTokenRepository: mockAccessTokenRepository,
        authenticationRepository: mockAuthenticationRepository,
        authTokenRepository: mockAuthTokenRepository,
        refreshTokenRepository: mockRefreshTokenRepository,
        userAttributesRepository: mockUserAttributesRepository);
  });

  group('Success: LoginUser', () {
    test('Should receive a successful response', () async {
      const userEmail = 'nagarjun_nagesh@outlook.com';
      const userPassword = 'password';
      const optionResponse = Some(UserResponse());
      const eitherUserResponseMonad =
          Right<Failure, Option<UserResponse>>(optionResponse);
      when(() => mockAuthenticationRepository!
              .loginUser(email: userEmail, password: userPassword))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));

      await loginUser.loginUser(email: userEmail, password: userPassword);
      verify(() => mockAuthenticationRepository!
          .loginUser(email: userEmail, password: userPassword));
      verify(() => mockUserAttributesRepository!.writeUserAttributes(
          optionResponse.getOrElse(() => const UserResponse())));
      verify(() => mockRefreshTokenRepository!.writeRefreshToken(
          optionResponse.getOrElse(() => const UserResponse())));
      verify(() => mockAuthTokenRepository!.writeAuthToken(
          optionResponse.getOrElse(() => const UserResponse())));
      verify(() => mockAccessTokenRepository!.writeAccessToken(
          optionResponse.getOrElse(() => const UserResponse())));
    });
  });

  group('Error: LoginUser', () {
    test('Option Failure: Should receive a failure response', () async {
      const userEmail = 'nagarjun_nagesh@outlook.com';
      const userPassword = 'password';
      const optionResponse = None<UserResponse>();
      const eitherUserResponseMonad =
          Right<Failure, Option<UserResponse>>(optionResponse);
      when(() => mockAuthenticationRepository!
              .loginUser(email: userEmail, password: userPassword))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));

      final userResponse =
          await loginUser.loginUser(email: userEmail, password: userPassword);
      final failureResponse =
          userResponse.fold((failure) => failure, (_) => GenericFailure());
      expect(userResponse.isLeft(), equals(true));
      expect(failureResponse, equals(EmptyResponseFailure()));
      verify(() => mockAuthenticationRepository!
          .loginUser(email: userEmail, password: userPassword));
      verifyNever(
          () => mockUserAttributesRepository!.writeUserAttributes(null));
      verifyNever(() => mockRefreshTokenRepository!.writeRefreshToken(null));
      verifyNever(() => mockAuthTokenRepository!.writeAuthToken(null));
      verifyNever(() => mockAccessTokenRepository!.writeAccessToken(null));
    });

    test('Response Failure: Should receive a failure response', () async {
      const userEmail = 'nagarjun_nagesh@outlook.com';
      const userPassword = 'password';
      final eitherUserResponseMonad =
          Left<Failure, Option<UserResponse>>(RedirectToSignupDueToFailure());
      when(() => mockAuthenticationRepository!
              .loginUser(email: userEmail, password: userPassword))
          .thenAnswer((_) => Future.value(eitherUserResponseMonad));

      final userResponse =
          await loginUser.loginUser(email: userEmail, password: userPassword);
      final failureResponse =
          userResponse.fold((failure) => failure, (_) => GenericFailure());
      expect(userResponse.isLeft(), equals(true));
      expect(failureResponse, equals(RedirectToSignupDueToFailure()));
      verify(() => mockAuthenticationRepository!
          .loginUser(email: userEmail, password: userPassword));
      verifyNever(
          () => mockUserAttributesRepository!.writeUserAttributes(null));
      verifyNever(() => mockRefreshTokenRepository!.writeRefreshToken(null));
      verifyNever(() => mockAuthTokenRepository!.writeAuthToken(null));
      verifyNever(() => mockAccessTokenRepository!.writeAccessToken(null));
    });
  });
}
