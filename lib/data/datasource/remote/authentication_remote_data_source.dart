import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:devicelocale/devicelocale.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_blitzbudget/core/error/exceptions.dart';
import 'package:mobile_blitzbudget/core/network/http_client.dart';

import '../../../app/screens/authentication/signup/signup_screen.dart';
import '../../../app/screens/authentication/verify/verify_screen.dart';
import '../../../utils/utils.dart';
import '../../constants/constants.dart' as constants;
import '../../model/user.dart';

// Header for API calls
var headers = {
  'Content-type': 'application/json;charset=UTF-8',
  'Accept': 'application/json'
};

/// Name Object for firstname and lastName
class _Name {
  String firstName;
  String surName;

  _Name(this.firstName, this.surName);
}

abstract class AuthenticationRemoteDataSource {
  Future<User> attemptLogin(String email, String password);

  Future<void> signupUser(
      String email, String password, String confirmPassword);

  Future<void> verifyEmail(String email, String password,
      String verificationCode, bool useVerifyURL);

  Future<bool> resendVerificationCode(String email);

  Future<void> forgotPassword(String email, String password);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final HttpClient _httpClient;
  static final _checkPassword = false;

  static final RegExp passwordExp = RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');
  static final RegExp emailExp = RegExp(r"^(?=.*[!#$%&'*+-\/=?^_`{|}~])");
  static final _userNotFoundException = 'UserNotFoundException';
  static final _userNotConfirmedException = 'UserNotConfirmedException';

  AuthenticationRemoteDataSourceImpl(this._httpClient);

  /// Login Screen
  ///
  /// Logging in with Username and Password
  /// If user is not found then signup the user
  @override
  Future<dynamic> attemptLogin(String email, String password) async {
    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    return _httpClient
        .post(constants.loginURL,
            body: jsonEncode({
              'username': email,
              'password': password,
              'checkPassword': _checkPassword
            }),
            headers: headers)
        .then<dynamic>((dynamic res) {
      developer.log('User Attributes' + res['UserAttributes'].toString());
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
  Future<void> signupUser(BuildContext context, String email, String password,
      String confirmPassword) async {
    if (isEmpty(confirmPassword)) {
      displayDialog(
          context, 'Empty Password', 'The confirm password cannot be empty');
      return;
    } else if (!passwordExp.hasMatch(confirmPassword)) {
      displayDialog(
          context, 'Invalid Password', 'The confirm password is not valid');
      return;
    } else if (confirmPassword != password) {
      displayDialog(context, 'Password Mismatch',
          'The confirm password and the password do not match');
      return;
    }

    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    var fullname = email.split('@')[0];
    var names = fetchNames(fullname);

    /// Add accept language headers
    headers['Accept-Language'] = await Devicelocale.currentLocale;

    /// Start signup process
    return _httpClient
        .post(constants.signupURL,
            body: jsonEncode({
              'username': email,
              'password': password,
              'firstname': names.firstName,
              'lastname': names.surName,
              'checkPassword': _checkPassword
            }),
            headers: headers)
        .then((dynamic res) {
      /// Error Type for signup
      /// UsernameExistsException is excluded from showing error message
      var errorMessage = res['errorMessage'] as String;
      if (res['errorType'] != null &&
          !errorMessage.contains('UsernameExistsException')) {
        displayDialog(context, 'Error signing up', errorMessage);
        return;
      }

      /// Navigate to the second screen using a named route.
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (context) => VerifyScreen(email: email, password: password),
        ),
      );

      return;
    });
  }

  /// Parse the user name with Email
  _Name fetchNames(String fullname) {
    Match match = emailExp.firstMatch(fullname);
    _Name name;

    if (match == null) {
      developer.log('No match found for $fullname');

      /// Sur name cannot be empty
      name = _Name(fullname, ' ');
    } else {
      /// TODO SPLIT the name and then assign it to first and surname
      name = _Name(fullname, ' ');
      developer.log(
          'Fullname $fullname, First match: ${match.start}, end Match: ${match.input}');
    }

    return name;
  }

  /// Verification Code
  ///
  /// Verify Email with confirmation code
  @override
  Future<void> verifyEmail(BuildContext context, String email, String password,
      String verificationCode, bool useVerifyURL) {
    /// Call verify / Confirm forgot password url
    final urlForAPICall = useVerifyURL
        ? constants.confirmSignupURL
        : constants.confirmForgotPasswordURL;

    /// Start signup process
    return _httpClient
        .post(urlForAPICall,
            body: jsonEncode({
              'username': email,
              'password': password,
              'confirmationCode': verificationCode,
              'doNotCreateWallet': false
            }),
            headers: headers)
        .then((dynamic res) async {
      /// Error Type for signup
      if (res['errorType'] != null) {
        displayDialog(
            context, 'Error Verifying', res['errorMessage'] as String);
        return;
      }

      /// Attempt to login after completing verification
      await attemptLogin(context, email, password);
      return;
    });
  }

  /// Resend Verification Code
  @override
  Future<bool> resendVerificationCode(BuildContext context, String email) {
    /// Start resending the verification code
    return _httpClient
        .post(constants.resendVerificationCodeURL,
            body: jsonEncode({'username': email}), headers: headers)
        .then((dynamic res) {
      /// Error Type for signup
      if (res['errorType'] != null) {
        displayDialog(context, 'Error', res['errorMessage'] as String);
        return false;
      }
      return true;
    });
  }

  /// Forgot Password Scenario to create a new one
  /// Redirects to Verify Email
  @override
  Future<void> forgotPassword(
      BuildContext context, String email, String password) {
    if (isEmpty(email)) {
      displayDialog(context, 'Empty Email', 'The email cannot be empty');
      return null;
    } else if (!EmailValidator.validate(email.trim())) {
      displayDialog(context, 'Invalid Email', 'The email is not valid');
      return null;
    } else if (isEmpty(password)) {
      displayDialog(context, 'Empty Password', 'The password cannot be empty');
      return null;
    } else if (!passwordExp.hasMatch(password)) {
      displayDialog(context, 'Invalid Password', 'The password is not valid');
      return null;
    }

    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();

    /// Start resending the verification code
    return _httpClient
        .post(constants.forgotPasswordURL,
            body: jsonEncode({'username': email}), headers: headers)
        .then((dynamic res) {
      /// Error Type for signup
      if (res['errorType'] != null) {
        displayDialog(context, 'Error', res['errorMessage'] as String);
        return;
      }

      /// Navigate to the second screen using a named route.
      /// Show resend verification code is false
      /// User verification URL as false
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (context) => VerifyScreen(
              email: email,
              password: password,
              useVerifyURL: false,
              showResendVerificationCode: false),
        ),
      );

      return;
    });
  }
}
