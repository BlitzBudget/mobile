import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api_exception.dart';
import 'package:mobile_blitzbudget/core/error/authentication_exception.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/model/response/user_response_model.dart';

import '../../../constants/constants.dart' as constants;

abstract class AuthenticationRemoteDataSource {
  Future<Option<UserResponseModel>> attemptLogin(
      {@required String email, @required String password});

  Future<void> signupUser({@required String email, @required String password});

  Future<void> verifyEmail(
      {@required String email,
      @required String password,
      @required String verificationCode,
      @required bool useVerifyURL});

  Future<void> resendVerificationCode(String email);

  Future<void> forgotPassword(String email);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImpl({@required this.httpClient});

  final HTTPClient httpClient;
  static const _checkPassword = false;
  static const _userNotFoundException = 'UserNotFoundException';
  static const _userNotConfirmedException = 'UserNotConfirmedException';
  static const _notAuthorizedException = 'NotAuthorizedException';

  /// Login Screen
  ///
  /// Logging in with Username and Password
  /// If user is not found then signup the user
  @override
  Future<Option<UserResponseModel>> attemptLogin(
      {@required String email, @required String password}) async {
    try {
      /// Convert email to lowercase and trim
      email = email.toLowerCase().trim();
      return await httpClient
          .post(constants.loginURL,
              body: jsonEncode({
                'username': email,
                'password': password,
                'checkPassword': _checkPassword
              }),
              headers: constants.headers,
              skipAuthCheck: true)
          .then<Option<UserResponseModel>>((dynamic res) {
        developer.log('User Attributes  ${res['UserAttributes']}');

        return (res is Map<String, dynamic>)
            ? Some(UserResponseModel.fromJSON(res))
            : const None();
      });
    } on APIException catch (e) {
      final res = e.res;
      if (res != null && res['errorType'] != null) {
        /// Conditionally process error messages
        if (includesStr(
                array: res['errorMessage'], value: _userNotFoundException)
            .getOrElse(() => false)) {
          /// Navigate user to signup screen
          throw UserNotFoundException();
        } else if (includesStr(
                array: res['errorMessage'], value: _userNotConfirmedException)
            .getOrElse(() => false)) {
          /// Navigate to the verification screen
          throw UserNotConfirmedException();
        } else if (includesStr(
                array: res['errorMessage'], value: _notAuthorizedException)
            .getOrElse(() => false)) {
          /// Exception to handle invalid credentials
          throw NotAuthorizedException();
        }
      }

      throw GenericAuthorizationException();
    }
  }

  /// SIGNUP module
  ///
  /// Used to signup the user with email & password
  /// Also invokes the Verification module
  @override
  Future<void> signupUser(
      {@required String email, @required String password}) async {
    try {
      /// Set accept language headers
      final headers = constants.headers;

      /// Start signup process
      return await httpClient.post(constants.signupURL,
          body: jsonEncode({
            'username': email,
            'password': password,
            'checkPassword': _checkPassword
          }),
          headers: headers,
          skipAuthCheck: true);
    } on APIException catch (e) {
      /// Fetch response from the exception
      final dynamic res = e.res;

      /// Error Type for signup
      /// UsernameExistsException is excluded from showing error message
      if (res != null &&
          isNotEmpty(res['errorType']) &&
          includesStr(
                  array: res['errorMessage'], value: 'UsernameExistsException')
              .getOrElse(() => false)) {
        throw UserAlreadyExistsException();
      }

      throw GenericAuthorizationException();
    }
  }

  /// Verification Code
  ///
  /// Verify Email with confirmation code
  @override
  Future<void> verifyEmail(
      {@required String email,
      @required String password,
      @required String verificationCode,
      @required bool useVerifyURL}) {
    /// Call verify / Confirm forgot password url
    final urlForAPICall = useVerifyURL
        ? constants.confirmSignupURL
        : constants.confirmForgotPasswordURL;

    /// Start signup process
    return httpClient.post(urlForAPICall,
        body: jsonEncode({
          'username': email,
          'password': password,
          'confirmationCode': verificationCode,
          'doNotCreateWallet': false
        }),
        headers: constants.headers,
        skipAuthCheck: true);
  }

  /// Resend Verification Code
  @override
  Future<void> resendVerificationCode(String email) {
    /// Start resending the verification code
    return httpClient.post(constants.resendVerificationCodeURL,
        body: jsonEncode({'username': email}),
        headers: constants.headers,
        skipAuthCheck: true);
  }

  /// Forgot Password Scenario to create a new one
  /// Redirects to Verify Email
  @override
  Future<void> forgotPassword(String email) {
    /// Start resending the verification code
    return httpClient.post(constants.forgotPasswordURL,
        body: jsonEncode({'username': email}),
        headers: constants.headers,
        skipAuthCheck: true);
  }
}
