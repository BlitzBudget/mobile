import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:mobile_blitzbudget/core/error/api-exception.dart';
import 'package:mobile_blitzbudget/core/error/authentication-exception.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';
import 'package:mobile_blitzbudget/core/utils/utils.dart';
import 'package:mobile_blitzbudget/data/model/response/user_response_model.dart';

import '../../constants/constants.dart' as constants;

abstract class AuthenticationRemoteDataSource {
  Future<UserResponseModel> attemptLogin(String email, String password);

  Future<void> signupUser(String email, String password, String firstName,
      String surName, String acceptLanguage);

  Future<void> verifyEmail(String email, String password,
      String verificationCode, bool useVerifyURL);

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
  Future<UserResponseModel> attemptLogin(String email, String password) async {
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
          .then<UserResponseModel>((dynamic res) {
        developer
            .log('User Attributes  ${res['UserAttributes'] as List<dynamic>}');

        return UserResponseModel.fromJSON(res as Map<String, dynamic>);
      });
    } on APIException catch (e) {
      dynamic res = e.res;
      if (res['errorType'] != null) {
        /// Conditionally process error messages
        if (includesStr(
            res['errorMessage'] as String, _userNotFoundException)) {
          /// Navigate user to signup screen
          throw UserNotFoundException();
        } else if (includesStr(
            res['errorMessage'] as String, _userNotConfirmedException)) {
          /// Navigate to the verification screen
          throw UserNotConfirmedException();
        } else if (includesStr(
            res['errorMessage'] as String, _notAuthorizedException)) {
          /// Exception to handle invalid credentials
          throw NotAuthorizedException();
        }
      }
    }
    return null;
  }

  /// SIGNUP module
  ///
  /// Used to signup the user with email & password
  /// Also invokes the Verification module
  @override
  Future<void> signupUser(String email, String password, String firstName,
      String surName, String acceptLanguage) async {
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
          includesStr(errorMessage, 'UsernameExistsException')) {
        throw UserAlreadyExistsException();
      }
    }
  }

  /// Verification Code
  ///
  /// Verify Email with confirmation code
  @override
  Future<void> verifyEmail(String email, String password,
      String verificationCode, bool useVerifyURL) {
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
