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

  Future<void> signupUser(
      {@required String email,
      @required String password,
      @required String firstName,
      @required String surName,
      @required String acceptLanguage});

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
  final HTTPClient httpClient;
  static final _checkPassword = false;

  static final _userNotFoundException = 'UserNotFoundException';
  static final _userNotConfirmedException = 'UserNotConfirmedException';
  static final _notAuthorizedException = 'NotAuthorizedException';

  AuthenticationRemoteDataSourceImpl({@required this.httpClient});

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
      return httpClient
          .post(constants.loginURL,
              body: jsonEncode({
                'username': email,
                'password': password,
                'checkPassword': _checkPassword
              }),
              headers: constants.headers)
          .then<Option<UserResponseModel>>((dynamic res) {
        developer
            .log('User Attributes  ${res['UserAttributes'] as List<dynamic>}');

        return Some(UserResponseModel.fromJSON(res as Map<String, dynamic>));
      });
    } on APIException catch (e) {
      dynamic res = e.res;
      if (res['errorType'] != null) {
        /// Conditionally process error messages
        if (includesStr(
                arr: res['errorMessage'] as String, val: _userNotFoundException)
            .getOrElse(() => false)) {
          /// Navigate user to signup screen
          throw UserNotFoundException();
        } else if (includesStr(
                arr: res['errorMessage'] as String,
                val: _userNotConfirmedException)
            .getOrElse(() => false)) {
          /// Navigate to the verification screen
          throw UserNotConfirmedException();
        } else if (includesStr(
                arr: res['errorMessage'] as String,
                val: _notAuthorizedException)
            .getOrElse(() => false)) {
          /// Exception to handle invalid credentials
          throw NotAuthorizedException();
        }
      }
    }
    return None();
  }

  /// SIGNUP module
  ///
  /// Used to signup the user with email & password
  /// Also invokes the Verification module
  @override
  Future<void> signupUser(
      {@required String email,
      @required String password,
      @required String firstName,
      @required String surName,
      @required String acceptLanguage}) async {
    try {
      /// Set accept language headers
      var headers = constants.headers;
      headers['Accept-Language'] = acceptLanguage;

      /// Start signup process
      return httpClient.post(constants.signupURL,
          body: jsonEncode({
            'username': email,
            'password': password,
            'firstname': firstName,
            'lastname': surName,
            'checkPassword': _checkPassword
          }),
          headers: headers);
    } on APIException catch (e) {
      /// Fetch response from the exception
      dynamic res = e.res;

      /// Error Type for signup
      /// UsernameExistsException is excluded from showing error message
      var errorMessage = res['errorMessage'] as String;
      if (isNotEmpty(res['errorType'] as String) &&
          includesStr(arr: errorMessage, val: 'UsernameExistsException')
              .getOrElse(() => false)) {
        throw UserAlreadyExistsException();
      }
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
        headers: constants.headers);
  }

  /// Resend Verification Code
  @override
  Future<void> resendVerificationCode(String email) {
    /// Start resending the verification code
    return httpClient.post(constants.resendVerificationCodeURL,
        body: jsonEncode({'username': email}), headers: constants.headers);
  }

  /// Forgot Password Scenario to create a new one
  /// Redirects to Verify Email
  @override
  Future<void> forgotPassword(String email) {
    /// Start resending the verification code
    return httpClient.post(constants.forgotPasswordURL,
        body: jsonEncode({'username': email}), headers: constants.headers);
  }
}
