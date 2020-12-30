import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:devicelocale/devicelocale.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../app/constants/constants.dart' as constants;
import '../../../app/screens/authentication/signup/signup_screen.dart';
import '../../../app/screens/authentication/verify/verify_screen.dart';
import '../../../core/network/network_helper.dart';
import '../../../utils/utils.dart';
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
  Future<void> attemptLogin(
      BuildContext context, String email, String password);

  Future<void> signupUser(BuildContext context, String email, String password,
      String confirmPassword);

  Future<void> verifyEmail(BuildContext context, String email, String password,
      String verificationCode, bool useVerifyURL);

  Future<bool> resendVerificationCode(BuildContext context, String email);

  Future<void> forgotPassword(
      BuildContext context, String email, String password);
}

class _AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final _loginURL = baseURL + "/profile/sign-in";
  static final _signupURL = baseURL + "/profile/sign-up";
  static final _forgotPasswordURL = baseURL + '/profile/forgot-password';
  static final _confirmSignupURL = baseURL + '/profile/confirm-sign-up';
  static final _confirmForgotPasswordURL =
      baseURL + '/profile/confirm-forgot-password';
  static final _resendVerificationCodeURL =
      baseURL + '/profile/resend-confirmation-code';
  static final _checkPassword = false;

  /// Create storage
  final _storage = new FlutterSecureStorage();
  static final RegExp passwordExp = new RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');
  static final RegExp emailExp = new RegExp(r"^(?=.*[!#$%&'*+-\/=?^_`{|}~])");
  static final _userNotFoundException = 'UserNotFoundException';
  static final _userNotConfirmedException = 'UserNotConfirmedException';

  /// Login Screen
  ///
  /// Logging in with Username and Password
  /// If user is not found then signup the user
  @override
  Future<void> attemptLogin(
      BuildContext context, String email, String password) async {
    if (isEmpty(email)) {
      displayDialog(context, "Empty Email", "The email cannot be empty");
      return null;
    } else if (!EmailValidator.validate(email.trim())) {
      displayDialog(context, "Invalid Email", "The email is not valid");
      return null;
    } else if (isEmpty(password)) {
      displayDialog(context, "Empty Password", "The password cannot be empty");
      return null;
    } else if (!passwordExp.hasMatch(password)) {
      displayDialog(context, "Invalid Password", "The password is not valid");
      return null;
    }

    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    return _netUtil
        .post(_loginURL,
            body: jsonEncode({
              "username": email,
              "password": password,
              "checkPassword": _checkPassword
            }),
            headers: headers)
        .then((dynamic res) {
      developer.log("User Attributes" + res['UserAttributes'].toString());
      if (res["errorType"] != null) {
        /// Conditionally process error messages
        if (includesStr(res["errorMessage"], _userNotFoundException)) {
          /// Signup user and parse the response
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignUpScreen(email: email, password: password),
            ),
          );
        } else if (includesStr(
            res["errorMessage"], _userNotConfirmedException)) {
          /// Navigate to the second screen using a named route.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyScreen(email: email, password: password),
            ),
          );
        } else {
          displayDialog(context, "Not Authorized",
              "The email or password entered is incorrect");
        }
        return null;
      }

      /// User
      User user = new User.fromJSON(res["UserAttributes"]);

      /// Store User Attributes
      _storeUserAttributes(user);

      /// Store Refresh Token
      _storeRefreshToken(res);

      /// Store Access Token
      storeAccessToken(res, _storage);

      /// Store Auth Token
      storeAuthToken(res, _storage);

      /// Navigate to the second screen using a named route.
      Navigator.pushNamed(context, constants.dashboardRoute);
      return;
    });
  }

  void _storeUserAttributes(User user) async {
    /// Write User Attributes
    await _storage.write(
        key: constants.userAttributes, value: jsonEncode(user.toJSON()));
  }

  void _storeRefreshToken(dynamic res) async {
    /// Write Refresh Token
    await _storage.write(
        key: constants.refreshToken,
        value: res["AuthenticationResult"]["RefreshToken"]);
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
          context, "Empty Password", "The confirm password cannot be empty");
      return;
    } else if (!passwordExp.hasMatch(confirmPassword)) {
      displayDialog(
          context, "Invalid Password", "The confirm password is not valid");
      return;
    } else if (confirmPassword != password) {
      displayDialog(context, "Password Mismatch",
          "The confirm password and the password do not match");
      return;
    }

    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    var fullname = email.split('@')[0];
    _Name names = fetchNames(fullname);

    /// Add accept language headers
    headers['Accept-Language'] = await Devicelocale.currentLocale;

    /// Start signup process
    return _netUtil
        .post(_signupURL,
            body: jsonEncode({
              "username": email,
              "password": password,
              "firstname": names.firstName,
              "lastname": names.surName,
              "checkPassword": _checkPassword
            }),
            headers: headers)
        .then((dynamic res) {
      /// Error Type for signup
      /// UsernameExistsException is excluded from showing error message
      if (res["errorType"] != null &&
          !res["errorMessage"].contains('UsernameExistsException')) {
        displayDialog(context, "Error signing up", res["errorMessage"]);
        return;
      }

      /// Navigate to the second screen using a named route.
      Navigator.push(
        context,
        MaterialPageRoute(
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
      developer.log('No match found for ${fullname}');

      /// Sur name cannot be empty
      name = _Name(fullname, ' ');
    } else {
      /// TODO SPLIT the name and then assign it to first and surname
      name = _Name(fullname, ' ');
      developer.log(
          'Fullname ${fullname}, First match: ${match.start}, end Match: ${match.input}');
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
    final String urlForAPICall =
        useVerifyURL ? _confirmSignupURL : _confirmForgotPasswordURL;

    /// Start signup process
    return _netUtil
        .post(urlForAPICall,
            body: jsonEncode({
              "username": email,
              "password": password,
              "confirmationCode": verificationCode,
              "doNotCreateWallet": false
            }),
            headers: headers)
        .then((dynamic res) async {
      /// Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error Verifying", res["errorMessage"]);
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
    return _netUtil
        .post(_resendVerificationCodeURL,
            body: jsonEncode({"username": email}), headers: headers)
        .then((dynamic res) {
      /// Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error", res["errorMessage"]);
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
      displayDialog(context, "Empty Email", "The email cannot be empty");
      return null;
    } else if (!EmailValidator.validate(email.trim())) {
      displayDialog(context, "Invalid Email", "The email is not valid");
      return null;
    } else if (isEmpty(password)) {
      displayDialog(context, "Empty Password", "The password cannot be empty");
      return null;
    } else if (!passwordExp.hasMatch(password)) {
      displayDialog(context, "Invalid Password", "The password is not valid");
      return null;
    }

    /// Convert email to lowercase and trim
    email = email.toLowerCase().trim();

    /// Start resending the verification code
    return _netUtil
        .post(_forgotPasswordURL,
            body: jsonEncode({"username": email}), headers: headers)
        .then((dynamic res) {
      /// Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error", res["errorMessage"]);
        return;
      }

      /// Navigate to the second screen using a named route.
      /// Show resend verification code is false
      /// User verification URL as false
      Navigator.push(
        context,
        MaterialPageRoute(
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

void storeAccessToken(dynamic res, FlutterSecureStorage storage) async {
  /// Write Access Token
  await storage.write(
      key: constants.accessToken,
      value: res["AuthenticationResult"]["AccessToken"]);
}

void storeAuthToken(dynamic res, FlutterSecureStorage storage) async {
  /// Write Id Token
  await storage.write(
      key: constants.authToken, value: res["AuthenticationResult"]["IdToken"]);
}
