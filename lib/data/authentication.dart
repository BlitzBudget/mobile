import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../screens/authentication/verify/verify_screen.dart';
import '../screens/authentication/signup/signup_screen.dart';
import '../utils/network_util.dart';
import '../models/user.dart';
import '../utils/utils.dart';
import '../constants.dart';
import '../routes.dart';

/// Name Object for firstname and lastName
class Name {
  String firstName;
  String surName;

  Name(this.firstName, this.surName);
}

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseURL = "https://api.blitzbudget.com";
  static final loginURL = baseURL + "/profile/sign-in";
  static final signupURL = baseURL + "/profile/sign-up";
  static final forgotPasswordURL = baseURL + '/profile/forgot-password';
  static final confirmSignupURL = baseURL + '/profile/confirm-sign-up';
  static final confirmForgotPasswordURL =
      baseURL + '/profile/confirm-forgot-password';
  static final resendVerificationCodeURL =
      baseURL + '/profile/resend-confirmation-code';
  var headers = {
    'Content-type': 'application/json;charset=UTF-8',
    'Accept': 'application/json'
  };
  static final checkPassword = false;
  // Create storage
  final storage = new FlutterSecureStorage();
  static final RegExp passwordExp = new RegExp(
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])(?=\S+$).{8,}$');
  static final RegExp emailExp = new RegExp(r"^(?=.*[!#$%&'*+-\/=?^_`{|}~])");
  static final userNotFoundException = 'UserNotFoundException';
  static final userNotConfirmedException = 'UserNotConfirmedException';

  /// Login Screen
  ///
  /// Logging in with Username and Password
  /// If user is not found then signup the user
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

    // Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    return _netUtil
        .post(loginURL,
            body: jsonEncode({
              "username": email,
              "password": password,
              "checkPassword": checkPassword
            }),
            headers: headers)
        .then((dynamic res) {
      developer.log("User Attributes" + res['UserAttributes'].toString());
      if (res["errorType"] != null) {
        // Conditionally process error messages
        if (includesStr(res["errorMessage"], userNotFoundException)) {
          // Signup user and parse the response
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignUpScreen(email: email, password: password),
            ),
          );
        } else if (includesStr(
            res["errorMessage"], userNotConfirmedException)) {
          // Navigate to the second screen using a named route.
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
      // User
      User user = new User.map(res["UserAttributes"]);
      // Store User Attributes
      _storeUserAttributes(user, storage);
      // Store Refresh Token
      _storeRefreshToken(res, storage);
      // Store Access Token
      _storeAccessToken(res, storage);
      // Store Auth Token
      _storeAuthToken(res, storage);

      // Navigate to the second screen using a named route.
      Navigator.pushNamed(context, dashboardRoute);
      return;
    });
  }

  void _storeUserAttributes(User user, FlutterSecureStorage storage) async {
    // Write User Attributes
    await storage.write(key: userAttributes, value: user.toString());
  }

  void _storeRefreshToken(dynamic res, FlutterSecureStorage storage) async {
    // Write Refresh Token
    await storage.write(
        key: refreshToken, value: res["AuthenticationResult"]["RefreshToken"]);
  }

  void _storeAccessToken(dynamic res, FlutterSecureStorage storage) async {
    // Write Access Token
    await storage.write(
        key: accessToken, value: res["AuthenticationResult"]["AccessToken"]);
  }

  void _storeAuthToken(dynamic res, FlutterSecureStorage storage) async {
    // Write Id Token
    await storage.write(
        key: authToken, value: res["AuthenticationResult"]["IdToken"]);
  }

  /// SIGNUP module
  ///
  /// Used to signup the user with email & password
  /// Also invokes the Verification module
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
    }

    // Convert email to lowercase and trim
    email = email.toLowerCase().trim();
    var fullname = email.split('@')[0];
    var names = fetchNames(fullname);

    // Add accept language headers
    headers['Accept-Language'] = await Devicelocale.currentLocale;

    // Start signup process
    return _netUtil
        .post(signupURL,
            body: jsonEncode({
              "username": email,
              "password": password,
              "firstname": names.firstName,
              "lastname": names.surName,
              "checkPassword": checkPassword
            }),
            headers: headers)
        .then((dynamic res) {
      // Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error signing up", res["errorMessage"]);
        return;
      }

      // Navigate to the second screen using a named route.
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
  Name fetchNames(String fullname) {
    Match match = emailExp.firstMatch(fullname);
    Name name;

    if (match == null) {
      developer.log('No match found for ${fullname}');
      // Sur name cannot be empty
      name = Name(fullname, ' ');
    } else {
      // TODO SPLIT the name and then assign it to first and surname
      name = Name(fullname, ' ');
      developer.log(
          'Fullname ${fullname}, First match: ${match.start}, end Match: ${match.input}');
    }

    return name;
  }

  /// Verification Code
  ///
  /// Verify Email with confirmation code
  Future<void> verifyEmail(BuildContext context, String email, String password,
      String verificationCode, bool useVerifyURL) {
    // Call verify / Confirm forgot password url
    final String urlForAPICall =
        useVerifyURL ? confirmSignupURL : confirmForgotPasswordURL;
    // Start signup process
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
          // Error Type for signup
          if (res["errorType"] != null) {
            displayDialog(context, "Error Verifying", res["errorMessage"]);
            return;
          }

          // Attempt to login after completing verification
          await attemptLogin(context, email, password);
          return;
        });
  }

  /// Resend Verification Code
  Future<bool> resendVerificationCode(BuildContext context, String email) {
    // Start resending the verification code
    return _netUtil
        .post(resendVerificationCodeURL,
            body: jsonEncode({"username": email}), headers: headers)
        .then((dynamic res) {
      // Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error", res["errorMessage"]);
        return false;
      }
      return true;
    });
  }

  // Forgot Password Scenario to create a new one
  // Redirects to Verify Email
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

    // Start resending the verification code
    return _netUtil
        .post(forgotPasswordURL,
            body: jsonEncode({"username": email}), headers: headers)
        .then((dynamic res) {
      // Error Type for signup
      if (res["errorType"] != null) {
        displayDialog(context, "Error", res["errorMessage"]);
        return;
      }

      // Navigate to the second screen using a named route.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyScreen(
              email: email, password: password, useVerifyURL: false),
        ),
      );

      return;
    });
  }
}
