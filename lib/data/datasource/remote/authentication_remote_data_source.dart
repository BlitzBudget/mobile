import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:mobile_blitzbudget/core/error/authorization-exception.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';

import '../../../utils/utils.dart';
import '../../constants/constants.dart' as constants;

abstract class AuthenticationRemoteDataSource {
  Future<dynamic> attemptLogin(String email, String password);

  Future<void> signupUser(String email, String password, String firstName,
      String surName, Map<String, String> headers);

  Future<void> verifyEmail(String email, String password,
      String verificationCode, bool useVerifyURL);

  Future<void> resendVerificationCode(String email);

  Future<void> forgotPassword(String email, String password);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final HTTPClient httpClient;
  static final _checkPassword = false;

  static final _userNotFoundException = 'UserNotFoundException';
  static final _userNotConfirmedException = 'UserNotConfirmedException';

  AuthenticationRemoteDataSourceImpl(this.httpClient);

  /// Login Screen
  ///
  /// Logging in with Username and Password
  /// If user is not found then signup the user
  @override
  Future<dynamic> attemptLogin(String email, String password) async {
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
        .then<dynamic>((dynamic res) {
      developer.log('User Attributes  ${res['UserAttributes'] as String}');
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
        } else {
          /// Exception to handle invalid credentials
          throw InvalidUserCredentialsException();
        }
      }
      return res;
    });
  }

  /// SIGNUP module
  ///
  /// Used to signup the user with email & password
  /// Also invokes the Verification module
  @override
  Future<void> signupUser(String email, String password, String firstName,
      String surName, Map<String, String> headers) async {
    /// Start signup process
    return httpClient
        .post(constants.signupURL,
            body: jsonEncode({
              'username': email,
              'password': password,
              'firstname': firstName,
              'lastname': surName,
              'checkPassword': _checkPassword
            }),
            headers: headers)
        .then((dynamic res) {
      /// Error Type for signup
      /// UsernameExistsException is excluded from showing error message
      var errorMessage = res['errorMessage'] as String;
      if (res['errorType'] != null &&
          !errorMessage.contains('UsernameExistsException')) {
        throw UserAlreadyExistsException();
      }
    });
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
    return httpClient
        .post(urlForAPICall,
            body: jsonEncode({
              'username': email,
              'password': password,
              'confirmationCode': verificationCode,
              'doNotCreateWallet': false
            }),
            headers: constants.headers)
        .then((dynamic res) async {
      /// Error Type for signup
      if (res['errorType'] != null) {
        throw UnableToVerifyCodeException();
      }
    });
  }

  /// Resend Verification Code
  @override
  Future<void> resendVerificationCode(String email) {
    /// Start resending the verification code
    return httpClient
        .post(constants.resendVerificationCodeURL,
            body: jsonEncode({'username': email}), headers: constants.headers)
        .then((dynamic res) {
      /// Error Type for signup
      if (res['errorType'] != null) {
        throw UnableToResendVerificationCode();
      }
    });
  }

  /// Forgot Password Scenario to create a new one
  /// Redirects to Verify Email
  @override
  Future<void> forgotPassword(String email, String password) {
    /// Start resending the verification code
    return httpClient
        .post(constants.forgotPasswordURL,
            body: jsonEncode({'username': email}), headers: constants.headers)
        .then((dynamic res) {
      /// Error Type for signup
      if (res['errorType'] != null) {
        throw UnableToInvokeForgotPasswordException();
      }
    });
  }
}
