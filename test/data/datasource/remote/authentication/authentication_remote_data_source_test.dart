import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/authentication_exception.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/data/constants/constants.dart' as constants;
import 'package:mobile_blitzbudget/data/datasource/remote/authentication/authentication_remote_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHTTPClientImpl extends Mock implements HTTPClientImpl {}

void main() {
  AuthenticationRemoteDataSourceImpl dataSource;
  HTTPClientImpl mockHTTPClientImpl;
  final mockEmail = 'john_doe@blitzbudget.com';
  final mockPassword = '12345678';

  setUp(() {
    mockHTTPClientImpl = MockHTTPClientImpl();
    dataSource =
        AuthenticationRemoteDataSourceImpl(httpClient: mockHTTPClientImpl);
  });

  group('Attempt to Login with email and password', () {
    final loginResponseAsString =
        fixture('responses/authentication/login_info.json');
    final loginResponseAsJSON =
        jsonDecode(loginResponseAsString) as Map<String, dynamic>;
    test(
      'Should return Login response once a correct email and password combination is provided',
      () async {
        // arrange
        when(mockHTTPClientImpl.post(constants.loginURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'checkPassword': false
                }),
                headers: constants.headers))
            .thenAnswer((_) async => loginResponseAsJSON);
        // act
        final loginResult = await dataSource.attemptLogin(
            email: mockEmail, password: mockPassword);
        // assert
        verify(mockHTTPClientImpl.post(constants.loginURL,
            body: jsonEncode({
              'username': mockEmail,
              'password': mockPassword,
              'checkPassword': false
            }),
            headers: constants.headers));

        // Option to user response
        var loginResp = loginResult.getOrElse(null);
        expect(loginResp.accessToken,
            equals(loginResponseAsJSON['AuthenticationResult']['AccessToken']));
        expect(
            loginResp.refreshToken,
            equals(
                loginResponseAsJSON['AuthenticationResult']['RefreshToken']));
      },
    );

    test(
      'Should return Invalid User Credentials exceptions response once an incorrect email and password combination is provided',
      () async {
        final notAuthorizedResponseAsString = fixture(
            'responses/authentication/login/not_authorized_exception.json');
        final notAuthorizedResponseAsJSON =
            jsonDecode(notAuthorizedResponseAsString) as Map<String, dynamic>;
        // arrange
        when(mockHTTPClientImpl.post(constants.loginURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'checkPassword': false
                }),
                headers: constants.headers))
            .thenThrow(ServerErrorException(notAuthorizedResponseAsJSON));

        // assert
        expect(
            () => dataSource.attemptLogin(
                email: mockEmail, password: mockPassword),
            throwsA(TypeMatcher<NotAuthorizedException>()));
      },
    );

    test(
      'Should return user not found exceptions response once an unregistered email and password combination is provided',
      () async {
        final userNotFoundExceptionAsString = fixture(
            'responses/authentication/login/user_not_found_exception.json');
        final userNotFoundExceptionAsJSON =
            jsonDecode(userNotFoundExceptionAsString) as Map<String, dynamic>;
        // arrange
        when(mockHTTPClientImpl.post(constants.loginURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'checkPassword': false
                }),
                headers: constants.headers))
            .thenThrow(ServerErrorException(userNotFoundExceptionAsJSON));

        // assert
        expect(
            () => dataSource.attemptLogin(
                email: mockEmail, password: mockPassword),
            throwsA(TypeMatcher<UserNotFoundException>()));
      },
    );

    test(
      'Should return user not confirmed exceptions response once an unverified email and password combination is provided',
      () async {
        final userNotConfirmedExceptionAsString = fixture(
            'responses/authentication/login/user_not_confirmed_exception.json');
        final userNotConfirmedExceptionAsJSON =
            jsonDecode(userNotConfirmedExceptionAsString)
                as Map<String, dynamic>;
        // arrange
        when(mockHTTPClientImpl.post(constants.loginURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'checkPassword': false
                }),
                headers: constants.headers))
            .thenThrow(ServerErrorException(userNotConfirmedExceptionAsJSON));

        // assert
        expect(
            () => dataSource.attemptLogin(
                email: mockEmail, password: mockPassword),
            throwsA(TypeMatcher<UserNotConfirmedException>()));
      },
    );
  });

  group('Attempt to Signup with email and password', () {
    final signupResponseAsString =
        fixture('responses/authentication/signup_info.json');
    final signupResponseAsJSON =
        jsonDecode(signupResponseAsString) as Map<String, dynamic>;
    var headers = constants.headers;
    headers['Accept-Language'] = 'en-US';
    test(
      'Should return Signup response once a correct email and password combination is provided',
      () async {
        // arrange
        when(mockHTTPClientImpl.post(constants.signupURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'checkPassword': false
                }),
                headers: headers))
            .thenAnswer((_) async =>
                signupResponseAsJSON); // Function with a fake parameter is called asynchronously to return a response
        // act
        await dataSource.signupUser(email: mockEmail, password: mockPassword);
        // assert
        verify(mockHTTPClientImpl.post(constants.signupURL,
            body: jsonEncode({
              'username': mockEmail,
              'password': mockPassword,
              'checkPassword': false
            }),
            headers: headers));
      },
    );

    test(
      'Should return user already exists exceptions response once a verified email and password combination is provided',
      () async {
        final userNameExistsExceptionAsString = fixture(
            'responses/authentication/signup/user_name_exists_exception.json');
        final userNameExistsExceptionAsJSON =
            jsonDecode(userNameExistsExceptionAsString) as Map<String, dynamic>;
        // arrange
        when(mockHTTPClientImpl.post(constants.signupURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'checkPassword': false
                }),
                headers: constants.headers))
            .thenThrow(ServerErrorException(userNameExistsExceptionAsJSON));

        // assert
        expect(
            () =>
                dataSource.signupUser(email: mockEmail, password: mockPassword),
            throwsA(TypeMatcher<UserAlreadyExistsException>()));
      },
    );
  });

  group('Attempt to verify email', () {
    final confirmSignupResponseAsString =
        fixture('responses/authentication/confirm_signup_info.json');
    final confirmSignupResponseAsJSON =
        jsonDecode(confirmSignupResponseAsString) as Map<String, dynamic>;
    var mockVerificationCode = '123456';
    test(
      'Should return verification response once a correct verification code and password combination is provided',
      () async {
        // arrange
        when(mockHTTPClientImpl.post(constants.confirmSignupURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'confirmationCode': mockVerificationCode,
                  'doNotCreateWallet': false
                }),
                headers: constants.headers))
            .thenAnswer((_) async =>
                confirmSignupResponseAsJSON); // Function with a fake parameter is called asynchronously to return a response
        // act
        await dataSource.verifyEmail(
            email: mockEmail,
            password: mockPassword,
            verificationCode: mockVerificationCode,
            useVerifyURL: true);
        // assert
        verify(mockHTTPClientImpl.post(constants.confirmSignupURL,
            body: jsonEncode({
              'username': mockEmail,
              'password': mockPassword,
              'confirmationCode': mockVerificationCode,
              'doNotCreateWallet': false
            }),
            headers: constants.headers));
      },
    );

    test(
      'Should return forgotpassword response once a correct verification code and password combination is provided',
      () async {
        // arrange
        when(mockHTTPClientImpl.post(constants.confirmForgotPasswordURL,
                body: jsonEncode({
                  'username': mockEmail,
                  'password': mockPassword,
                  'confirmationCode': mockVerificationCode,
                  'doNotCreateWallet': false
                }),
                headers: constants.headers))
            .thenAnswer((_) async =>
                confirmSignupResponseAsJSON); // Function with a fake parameter is called asynchronously to return a response
        // act
        await dataSource.verifyEmail(
            email: mockEmail,
            password: mockPassword,
            verificationCode: mockVerificationCode,
            useVerifyURL: false);
        // assert
        verify(mockHTTPClientImpl.post(constants.confirmForgotPasswordURL,
            body: jsonEncode({
              'username': mockEmail,
              'password': mockPassword,
              'confirmationCode': mockVerificationCode,
              'doNotCreateWallet': false
            }),
            headers: constants.headers));
      },
    );
  });

  group('Attempt to resendverification code email', () {
    final resendVerificationCodeResponseAsString =
        fixture('responses/authentication/resend_verification_code.json');
    final resendVerificationCodeResponseAsJSON =
        jsonDecode(resendVerificationCodeResponseAsString)
            as Map<String, dynamic>;
    test(
      'Should return resend verification response once an appropriate email is provided',
      () async {
        // arrange
        when(mockHTTPClientImpl.post(constants.resendVerificationCodeURL,
                body: jsonEncode({'username': mockEmail}),
                headers: constants.headers))
            .thenAnswer((_) async =>
                resendVerificationCodeResponseAsJSON); // Function with a fake parameter is called asynchronously to return a response
        // act
        await dataSource.resendVerificationCode(mockEmail);
        // assert
        verify(mockHTTPClientImpl.post(constants.resendVerificationCodeURL,
            body: jsonEncode({'username': mockEmail}),
            headers: constants.headers));
      },
    );
  });

  group('Attempt to invoke forgot password flow', () {
    final forgotPasswordResponseAsString =
        fixture('responses/authentication/forgot_password_info.json');
    final forgotPasswordResponseAsJSON =
        jsonDecode(forgotPasswordResponseAsString) as Map<String, dynamic>;
    test(
      'Should return forgot password response once an appropriate email is provided',
      () async {
        // arrange
        when(mockHTTPClientImpl.post(constants.forgotPasswordURL,
                body: jsonEncode({'username': mockEmail}),
                headers: constants.headers))
            .thenAnswer((_) async =>
                forgotPasswordResponseAsJSON); // Function with a fake parameter is called asynchronously to return a response
        // act
        await dataSource.forgotPassword(mockEmail);
        // assert
        verify(mockHTTPClientImpl.post(constants.forgotPasswordURL,
            body: jsonEncode({'username': mockEmail}),
            headers: constants.headers));
      },
    );
  });
}
